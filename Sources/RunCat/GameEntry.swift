@main
struct EntryPoint {
    static func main() {
        var n = UInt8.zero
        var t = UInt8.zero
        let renderer = Renderer(mode: 0, flags: UInt16(1 << 12))

        renderer.set(tiles: Cat.tileData)

        var sprites: [ObjectAttribute] = (0 ..< 30).map { index in
            let charNo = Cat.tileMap[Int(n)][index]
            return ObjectAttribute(
                x: 96 + 8 * (UInt16(index) % 6),
                y: 60 + 8 * (UInt16(index) / 6),
                charNo: charNo,
                paletteNo: 0
            )
        }

        renderer.update(sprites: sprites)

        while true {
            renderer.waitForVSync()

            n = (n + 1) % 5
            sprites.indices.forEach { index in
                sprites[index].charNo = Cat.tileMap[Int(n)][index]
            }
            renderer.update(sprites: sprites)
        }
    }
}
