@main
struct EntryPoint {
    static func main() {
        var n = Int.zero

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
        let tileData = Cat.tileDataList.flatMap { $0 }
        tileData.withUnsafeBufferPointer { buffer in
            objectTiles.update(from: buffer.baseAddress!, count: buffer.count)
        }

        let oam = UnsafeMutablePointer<ObjectAttribute>(bitPattern: 0x07000000)!
        oam.update(repeating: ObjectAttribute(), count: 128)

        var sprites = (UInt16.zero ..< 30).map { index in
            ObjectAttribute(x: 96 + 8 * (index % 6), y: 60 + 8 * (index / 6), charNo: index, paletteNo: 0)
        }
        sprites.indices.forEach { index in
            oam[index] = sprites[index]
        }

        let plotter = Plotter()
        plotter.set(mode: 0, flags: UInt16(1 << 12))

        while true {
            plotter.waitForVSync()

            n = (n + 1) % 5

            sprites.indices.forEach { index in
                let charNo = UInt16(30 * n + index)
                sprites[index].charNo = charNo
                oam[index].attr2 = (oam[index].attr2 & 0xfc00) | (charNo & 0x03ff)
            }
        }
    }
}
