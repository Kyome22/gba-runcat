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
        switch kind {
        case .cat:
            let tileMatrixList: [[[Tile]]] = Cat.allCases.map { cat in
                let image = cat.image
                var colors = convertToColors(from: image)
                colors = resize(colors: colors, to: CGSize(width: 64, height: 64))
                return convertToTileMatrix(colors: colors, width: image.width)
            }
            switch format {
            case .count:
                printCount(tileMatrixList: tileMatrixList)
            case .map:
                printMap(tileMatrixList: tileMatrixList, digit: 3)
            case .data:
                printData(tileMatrixList: tileMatrixList)
            }
        case .road:
            let tileMatrixList: [[[Tile]]] = Road.allCases.map { road in
                let image = road.image
                let colors = convertToColors(from: image)
                return convertToTileMatrix(colors: colors, width: image.width)
            }
            switch format {
            case .count:
                printCount(tileMatrixList: tileMatrixList)
            case .map:
                printMap(tileMatrixList: tileMatrixList, digit: 2)
            case .data:
                printData(tileMatrixList: tileMatrixList)
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

    private func resize(colors: [Color], to size: CGSize) -> [Color] {
        let count = (Int(size.width * size.height) - colors.count)
        return [Color](repeating: Color.c0, count: count) + colors
    }

    private func convertToUInt32Array(colorMatrix: [[Color]]) -> [UInt32] {
        colorMatrix.map { colors in
            colors.reversed().reduce(into: UInt32.zero) { acc, color in
                acc = (acc << 4) | UInt32(color.rawValue & 0xF)
            }
        }
    }

    private func convertToTileMatrix(colors: [Color], width: Int) -> [[Tile]] {
        let height = colors.count / width
        let tilesPerRow = width / 8
        let tilesPerColumn = height / 8

        return (0 ..< tilesPerColumn).map { tileRow in
            (0 ..< tilesPerRow).map { tileCol in
                let startY = 8 * tileRow
                let startX = 8 * tileCol

                let tileColors = (0 ..< 8).map { y in
                    (0 ..< 8).map { x in
                        colors[(startY + y) * width + (startX + x)]
                    }
                }

                let data = convertToUInt32Array(colorMatrix: tileColors)
                return Tile(data: data)
            }
        }
    }

    private func printCount(tileMatrixList: [[[Tile]]]) {
        let content = [
            "frame: \(tileMatrixList.count)",
            "row: \(tileMatrixList[0].count)",
            "column: \(tileMatrixList[0][0].count)",
        ].joined(separator: ",\n")
        print(content)
    }

    private func printMap(tileMatrixList: [[[Tile]]], digit: Int) {
        let row = tileMatrixList[0].count
        let column = tileMatrixList[0][0].count
        let content = tileMatrixList.indices.map { index in
            String(format: "%-\(digit)d", row * column * index).replacingOccurrences(of: " ", with: "_")
        }.joined(separator: ", ")
        print("[\(content)]")
    }

    private func printData(tileMatrixList: [[[Tile]]]) {
        let tileData: [UInt32] = tileMatrixList.flatMap { tileMatrix in
            tileMatrix.flatMap { tiles in
                tiles.flatMap { tile in
                    tile.data
                }
            }
        }
        let content = tileData.chunked(by: 8).map { values in
            values.map { value in
                String(format: "    0x%08X,", value)
            }.joined(separator: "\n")
        }.joined(separator: "\n\n")
        print("[\n\(content)\n]")
    }
}

enum Kind: String {
    case cat
    case road
}

enum Format: String {
    case count
    case map
    case data
}

struct Tile: Hashable {
    var data: [UInt32]
}
