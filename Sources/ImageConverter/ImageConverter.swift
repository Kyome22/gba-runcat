import CoreGraphics

struct ImageConverter {
    func run() throws {
        let image = Cat.running(.frame0).image
        guard let (colors, width, height) = colorMap(from: image, scale: 0.4) else {
            return
        }
        let tiles = tileMap(from: colors, width: width, height: height)

        tiles.forEach { item in
            item.chunked(by: 8).forEach { colors in
                let value = colors.reversed().reduce(into: "0x") {
                    $0 += "\($1.rawValue)"
                }
                print("\(value),")
            }
            print()
        }
    }

    private func colorMap(from image: CGImage, scale: CGFloat) -> ([Color], Int, Int)? {
        let width = Int(scale * CGFloat(image.width))
        let height = Int(scale * CGFloat(image.height))
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
            return nil
        }
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        cgContext.draw(image, in: rect)
        guard let _ = cgContext.makeImage() else {
            return nil
        }
        let colors = stride(from: .zero, to: pixels.count, by: 4).map {
            Color(value: pixels[$0 + 3])
        }
        return (colors, width, height)
    }

    private func tileMap(from colors: [Color], width: Int, height: Int) -> [[Color]] {
        stride(from: .zero, to: height, by: 8).flatMap { baseY in
            stride(from: .zero, to: width, by: 8).map { baseX in
                (0 ..< 8).flatMap { y in
                    (0 ..< 8).map { x in
                        colors[(baseY + y) * width + (baseX + x)]
                    }
                }
            }
        }
    }
}
