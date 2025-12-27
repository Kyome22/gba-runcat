@main
struct EntryPoint {
    static func main() {
        var n = UInt8.zero
        let renderer = Renderer(mode: 0, flags: UInt16(1 << 12))
        var timer = Timer(milliseconds: 100)
        let screenSize = Size.screen
        let catSize = Size.cat

        renderer.set(tiles: Cat.tileData)

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

        renderer.update(sprites: sprites)

        while true {
            renderer.waitForVSync()

            if timer.hasElapsed() {
                n = (n + 1) % 15
                sprites.indices.forEach { index in
                    sprites[index].charNumber = Cat.tileMap[Int(n)][index]
                }
                renderer.update(sprites: sprites)
            }
        }
    }
}
