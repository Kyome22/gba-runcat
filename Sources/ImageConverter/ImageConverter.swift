import CoreGraphics
import Foundation

// Screen   240x160 = 8*30x8*20 = 16*15x16*10
// Cat      64x48   = 8*8x8*6   = 16*4x16*3
// Road     16x32   = 8*2x8*4   = 16*1x16*2

struct ImageConverter {
    var kind: Kind
    var format: Format

    init(kind: String, format: String) {
        self.kind = Kind(rawValue: kind) ?? .cat
        self.format = Format(rawValue: format) ?? .map
    }

    func run() throws {
        let tileSize = 16
        let scale = (tileSize * tileSize) / (8 * 8)
        switch kind {
        case .cat:
            let tileMatrixList: [[[Tile]]] = Cat.allCases.map { cat in
                let image = cat.image
                let colors = convertToColors(from: image)
                return convertToTileMatrix(colors: colors, width: image.width, tileSize: 16, number: cat.number)
            }
            let tileSets = convertToTileSets(from: tileMatrixList)
            switch format {
            case .total:
                print(tileSets.count * scale)
            case .map:
                printMap(total: tileMatrixList.count, chunk: tileMatrixList[0][0].count, tileSets: tileSets, scale: scale, digit: 3)
            case .data:
                printData(tileSets: tileSets)
            }
        case .road:
            let tileMatrixList: [[[Tile]]] = Road.allCases.map { road in
                let image = road.image
                let colors = convertToColors(from: image)
                return convertToTileMatrix(colors: colors, width: image.width, tileSize: 16, number: road.number)
            }
            let tileSets = convertToTileSets(from: tileMatrixList)
            switch format {
            case .total:
                print(tileSets.count * scale)
            case .map:
                printMap(total: tileMatrixList.count, chunk: tileMatrixList[0][0].count, tileSets: tileSets, scale: scale, digit: 2)
            case .data:
                printData(tileSets: tileSets)
            }
        }
    }

    private func convertToColors(from image: CGImage) -> [Color] {
        let width = image.width
        let height = image.height
        var pixels = [UInt8](repeating: .zero, count: 4 * width * height)
        let alphaInfo = CGImageAlphaInfo.premultipliedLast.rawValue
        guard let cgContext = CGContext(
            data: &pixels,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 4 * width,
            space: image.colorSpace,
            bitmapInfo: CGBitmapInfo(rawValue: alphaInfo).union(.byteOrder32Big)
        ) else {
            fatalError()
        }
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        cgContext.draw(image, in: rect)
        guard let _ = cgContext.makeImage() else {
            fatalError()
        }
        let colors = stride(from: .zero, to: pixels.count, by: 4).map {
            Color(value: pixels[$0 + 3])
        }
        return colors
    }

    private func remap(colorMatrix: [[Color]], blockSize: Int) -> [[Color]] {
        let tileHeight = colorMatrix.count
        let tileWidth = colorMatrix[0].count
        let blocksPerRow = tileWidth / blockSize
        let blocksPerColumn = tileHeight / blockSize

        return (0 ..< blocksPerColumn).flatMap { blockRow in
            (0 ..< blocksPerRow).flatMap { blockCol in
                let startY = blockRow * blockSize
                let startX = blockCol * blockSize
                let blockColors = (0 ..< blockSize).map { y in
                    (0 ..< blockSize).map { x in
                        colorMatrix[startY + y][startX + x]
                    }
                }
                return blockColors
            }
        }
    }

    private func convertToUInt32Array(colorMatrix: [[Color]]) -> [UInt32] {
        colorMatrix.map { colors in
            colors.reversed().reduce(into: UInt32.zero) { acc, color in
                acc = (acc << 4) | UInt32(color.rawValue & 0xF)
            }
        }
    }

    private func convertToTileMatrix(colors: [Color], width: Int, tileSize: Int, number: Int) -> [[Tile]] {
        let height = colors.count / width
        let tilesPerRow = width / tileSize
        let tilesPerColumn = height / tileSize

        return (0 ..< tilesPerColumn).map { tileRow in
            (0 ..< tilesPerRow).map { tileCol in
                let startY = tileRow * tileSize
                let startX = tileCol * tileSize
                var tileColors = (0 ..< tileSize).map { y in
                    (0 ..< tileSize).map { x in
                        colors[(startY + y) * width + (startX + x)]
                    }
                }
                tileColors = remap(colorMatrix: tileColors, blockSize: 8)
                let data = convertToUInt32Array(colorMatrix: tileColors)
                return Tile(position: .init(number: number, x: tileCol, y: tileRow), data: data)
            }
        }
    }

    private func convertToTileSets(from tileMatrixList: [[[Tile]]]) -> [TileSet] {
        var dict = [UUID : TileSet]()
        tileMatrixList.forEach { tileMatrix in
            tileMatrix.forEach { tiles in
                tiles.forEach { tile in
                    if let tileSet = dict.first(where: { _, value in value.data == tile.data })?.value {
                        dict[tileSet.id]?.positions.append(tile.position)
                    } else {
                        let tileSet = TileSet(data: tile.data, positions: [tile.position])
                        dict[tileSet.id] = tileSet
                    }
                }
            }
        }
        return dict.values
            .map { tileSet in
                let positions = tileSet.positions
                    .sorted { a, b in a.x < b.x }
                    .sorted { a, b in a.y < b.y }
                    .sorted { a, b in a.number < b.number }
                return TileSet(data: tileSet.data, positions: positions)
            }
            .sorted { a, b in
                a.positions.first!.x < b.positions.first!.x
            }
            .sorted { a, b in
                a.positions.first!.y < b.positions.first!.y
            }
            .sorted { a, b in
                a.positions.count > b.positions.count
            }
            .sorted { a, b in
                a.positions.first!.number < b.positions.first!.number
            }
    }

    private func convertToPositionWithIndexList(from tileSets: [TileSet], number: Int, scale: Int) -> [PositionWithIndex] {
        tileSets.enumerated()
            .flatMap { index, tileSet -> [PositionWithIndex] in
                tileSet.positions.map { PositionWithIndex(position: $0, index: index * scale) }
            }
            .filter { value in
                value.position.number == number
            }
            .sorted { a, b in
                a.position.x < b.position.x
            }
            .sorted { a, b in
                a.position.y < b.position.y
            }
    }

    private func printMap(total: Int, chunk: Int, tileSets: [TileSet], scale: Int, digit: Int) {
        let content = (0 ..< total).map { number in
            let positionWithIndexList = convertToPositionWithIndexList(from: tileSets, number: number, scale: scale)
            return positionWithIndexList.chunked(by: chunk).map { value in
                let str = value.map {
                    String(format: "%-\(digit)d", $0.index).replacingOccurrences(of: " ", with: "_")
                }.joined(separator: ", ")
                return "    \(str),"
            }.joined(separator: "\n")
        }.joined(separator: "\n],\n[\n")
        print("[\n\(content)\n]")
    }

    private func printData(tileSets: [TileSet]) {
        let content = tileSets.map { tileSet in
            tileSet.data.chunked(by: 8).map { value in
                value.map { value in
                    String(format: "    0x%08X,", value)
                }.joined(separator: "\n")
            }.joined(separator: "\n\n")
        }.joined(separator: "\n\n")
        print("[\n\(content)\n]")
    }
}

enum Kind: String {
    case cat
    case road
}

enum Format: String {
    case total
    case map
    case data
}

struct Position: Hashable {
    var number: Int
    var x: Int
    var y: Int
}

struct Tile: Hashable {
    var position: Position
    var data: [UInt32]
}

struct TileSet: Hashable {
    var id = UUID()
    var data: [UInt32]
    var positions: [Position]
}

struct PositionWithIndex: Hashable {
    var position: Position
    var index: Int
}
