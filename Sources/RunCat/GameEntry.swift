@main
struct EntryPoint {
    static func main() {
        let objectPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
        objectPalettes.update(repeating: 0, count: 256)
        objectPalettes[1] = 0x1084
        objectPalettes[2] = 0x2529
        objectPalettes[3] = 0x35AD
        objectPalettes[4] = 0x4A52
        objectPalettes[5] = 0x56D6
        objectPalettes[6] = 0x6F7B
        objectPalettes[7] = 0x7FFF

        let objectTiles = UnsafeMutablePointer<UInt32>(bitPattern: 0x06010000)!
        objectTiles.update(from: Cat.tileData, count: Cat.tileData.count)

        let objectAttributeMemory = UnsafeMutablePointer<ObjectAttribute>(bitPattern: 0x07000000)!
        objectAttributeMemory.update(repeating: ObjectAttribute(attr0: 0x0200), count: 128)

        let sprites: [ObjectAttribute] = (0 ..< 5).flatMap { n in
            (0 ..< 30).compactMap { index in
                let charNo = Cat.tileMap[n][index]
                guard charNo > 0 else { return nil }
                return ObjectAttribute(
                    x: 48 * UInt16(n) + 8 * (UInt16(index) % 6),
                    y: 60 + 8 * (UInt16(index) / 6),
                    charNo: charNo,
                    paletteNo: 0
                )
            }
        }
        sprites.indices.forEach { index in
            objectAttributeMemory[index] = sprites[index]
        }

        let plotter = Plotter()
        plotter.set(mode: 0, flags: UInt16(1 << 12))

        while true {
            plotter.waitForVSync()

            // n = (n + 1) % 5
            // sprites.indices.forEach { index in
            //     sprites[index].charNo = Cat.tileMap[n][index]
            //     oam[index] = sprites[index]
            // }
        }
    }
}
