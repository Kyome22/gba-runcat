import CoreGraphics
import Foundation

// 240x160 -> 30x20単位
// 猫は 64x48 = 8*8 x 8*6
// 地面は 16x32 = 8*2 x 8*4

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
            let tileData = Cat.allCases.map { cat in
                let image = cat.image
                let colors = convertToColors(from: image)
                return convertToTileData(from: colors, width: image.width, height: image.height)
            }
            let chunk = Cat.RunningCat.frame0.image.width / 8
            let tileDataSets = convertToTileDataSets(from: tileData, chunk: chunk)
            switch format {
            case .map:
                printMap(total: tileData.count, chunk: chunk, tileDataSets: tileDataSets, digit: 3)
            case .data:
                printData(tileDataSets: tileDataSets)
            }
        case .road:
            let tileData = Road.allCases.map { road in
                let image = road.image
                let colors = convertToColors(from: image)
                return convertToTileData(from: colors, width: image.width, height: image.height)
            }
            let chunk = Road.sprout.image.width / 8
            let tileDataSets = convertToTileDataSets(from: tileData, chunk: chunk)
            switch format {
            case .map:
                printMap(total: tileData.count, chunk: chunk, tileDataSets: tileDataSets, digit: 2)
            case .data:
                printData(tileDataSets: tileDataSets)
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

    private func convertToTileData(from colors: [Color], width: Int, height: Int) -> [UInt32] {
        let array: [[Color]] = stride(from: .zero, to: height, by: 8).flatMap { baseY in
            stride(from: .zero, to: width, by: 8).map { baseX in
                (0 ..< 8).flatMap { y in
                    (0 ..< 8).map { x in
                        colors[(baseY + y) * width + (baseX + x)]
                    }
                }
            }
        }
        return array.flatMap { colors in
            colors.chunked(by: 8).map { colors in
                colors.reversed().reduce(into: UInt32.zero) { acc, color in
                    acc = (acc << 4) | UInt32(color.rawValue & 0xF)
                }
            }
        }
    }

    private func convertToTileDataSets(from tileData: [[UInt32]], chunk: Int) -> [TileDataSet] {
        let original = tileData.map { $0.chunked(by: 8) }
        let chunkedTileData: [[[TileData]]] = original.enumerated().map { number, frame in
            frame.chunked(by: chunk).enumerated().map { y, slice in
                slice.enumerated().map { x, data in
                    TileData(position: .init(number: number, x: x, y: y), data: data)
                }
            }
        }
        var dict = [UUID : TileDataSet]()
        chunkedTileData.forEach { array1 in
            array1.forEach { array2 in
                array2.forEach { array3 in
                    if let tileDataSet = dict.first(where: { _, value in value.data == array3.data })?.value {
                        dict[tileDataSet.id]?.positions.append(array3.position)
                    } else {
                        let tileDataSet = TileDataSet(data: array3.data, positions: [array3.position])
                        dict[tileDataSet.id] = tileDataSet
                    }
                }
            }
        }
        return dict.values
            .map { tileDataSet in
                let positions = tileDataSet.positions
                    .sorted { a, b in a.x < b.x }
                    .sorted { a, b in a.y < b.y }
                    .sorted { a, b in a.number < b.number }
                return TileDataSet(data: tileDataSet.data, positions: positions)
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

    private func convertToPositionWithIndexList(from tileDataSets: [TileDataSet], number: Int) -> [PositionWithIndex] {
        tileDataSets.enumerated()
            .flatMap { index, tileDataSet -> [PositionWithIndex] in
                tileDataSet.positions.map { PositionWithIndex(position: $0, index: index) }
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

    private func printMap(total: Int, chunk: Int, tileDataSets: [TileDataSet], digit: Int) {
        let content = (0 ..< total).map { number in
            let positionWithIndexList = convertToPositionWithIndexList(from: tileDataSets, number: number)
            return positionWithIndexList.chunked(by: chunk).map { value in
                let str = value.map {
                    String(format: "%-\(digit)d", $0.index).replacingOccurrences(of: " ", with: "_")
                }.joined(separator: ", ")
                return "    \(str),"
            }.joined(separator: "\n")
        }.joined(separator: "\n],\n[\n")
        print("[\n\(content)\n]")
    }

    private func printData(tileDataSets: [TileDataSet]) {
        let content = tileDataSets.map { tileDataSet in
            tileDataSet.data.map { value in
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
    case map
    case data
}

struct Position: Hashable {
    var number: Int
    var x: Int
    var y: Int
}

struct TileData: Hashable {
    var position: Position
    var data: [UInt32]
}

struct TileDataSet: Hashable {
    var id = UUID()
    var data: [UInt32]
    var positions: [Position]
}

struct PositionWithIndex: Hashable {
    var position: Position
    var index: Int
}
