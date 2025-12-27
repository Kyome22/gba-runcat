@main
struct EntryPoint {
    static func main() {
        var n = UInt8.zero
        var m = UInt8.zero
        let renderer = Renderer(mode: 0, flags: UInt16(1 << 12))
        var timer = Timer(milliseconds: 100)
        let screenSize = Size.screen
        let catSize = Size.cat

        let tileData = Cat.tileData + Road.tileData
        renderer.set(tiles: tileData)

        let catTileTotal = Int(Cat.tileWidth * Cat.tileHeight)
        let originX = (screenSize.width - catSize.width) / 2
        let originY = (screenSize.height - catSize.height) / 2
        var sprites: [ObjectAttribute] = (0 ..< catTileTotal).map { index in
            let charNumber = Cat.tileMap[Int(n)][index]
            return ObjectAttribute(
                x: originX + 8 * (UInt16(index) % Cat.tileWidth),
                y: originY + 8 * (UInt16(index) / Cat.tileWidth),
                charNumber: charNumber,
                paletteNumber: 0
            )
        }

        let offset = UInt16(Cat.tileData.count / 8)
        let roadTileMap = Road.tileMap.map { $0.map { value in value + offset } }
        let roadTileTotal = Int(Road.tileWidth * Road.tileHeight)
        sprites += (0 ..< roadTileTotal).map { index in
            let charNumber = roadTileMap[Int(m)][index]
            return ObjectAttribute(
                x: 8 * (UInt16(index) % Road.tileWidth),
                y: 8 * (UInt16(index) / Road.tileWidth),
                charNumber: charNumber,
                paletteNumber: 0
            )
        }

        renderer.update(sprites: sprites)

        while true {
            renderer.waitForVSync()

            if timer.hasElapsed() {
                n = (n + 1) % 15
                (0 ..< catTileTotal).forEach { index in
                    sprites[index].charNumber = Cat.tileMap[Int(n)][index]
                }

                m = (m + 1) % 4
                (0 ..< roadTileTotal).forEach { index in
                    sprites[catTileTotal + index].charNumber = roadTileMap[Int(m)][index]
                }
                renderer.update(sprites: sprites)
            }
        }
    }
}
