import _Volatile

struct Renderer {
    private var screenSize = Size.screen
    private var verticalCount = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x4000006)

    init(mode: UInt16, flags: UInt16) {
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000000)!
        displayControl.pointee = (mode & 0x0007) | (flags & 0xfff8)

        let objectPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
        objectPalettes.update(repeating: 0, count: 256)
        objectPalettes[1] = 0x1084
        objectPalettes[2] = 0x2529
        objectPalettes[3] = 0x35AD
        objectPalettes[4] = 0x4A52
        objectPalettes[5] = 0x56D6
        objectPalettes[6] = 0x6F7B
        objectPalettes[7] = 0x7FFF

        objectAttributeMemory().update(repeating: ObjectAttribute(attr0: 0x0200), count: 128)
    }

    func waitForVSync() {
        let threshold = screenSize.height
        while verticalCount.load() >= threshold {}
        while verticalCount.load() < threshold {}
    }

    func set(tiles: [UInt32]) {
        let objectTiles = UnsafeMutablePointer<UInt32>(bitPattern: 0x06010000)!
        objectTiles.update(from: tiles, count: tiles.count)
    }

    @inline(never)
    private func objectAttributeMemory() -> UnsafeMutablePointer<ObjectAttribute> {
        UnsafeMutablePointer<ObjectAttribute>(bitPattern: 0x07000000)!
    }

    func update(sprites: [ObjectAttribute]) {
        sprites.indices.forEach { index in
            objectAttributeMemory()[index] = sprites[index]
        }
    }
}
