import _Volatile

struct Renderer {
    private var screenSize = Size(width: 240, height: 160)
    private var verticalCount = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x4000006)

    init() {
        let mode = UInt16.zero
        let isEnabledBackground0: UInt16 = 0x0100
        let isEnabledObject: UInt16 = 0x1000
        let flags = isEnabledBackground0 | isEnabledObject
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000000)!
        displayControl.pointee = (mode & 0x0007) | (flags & 0xFFF8)

        let backgroundControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000008)!
        backgroundControl.pointee = 0

        let backgroundPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000000)!
        backgroundPalettes.update(repeating: 0, count: 1)
        backgroundPalettes[0] = Color.background.rawValue
        let count = Int(screenSize.width * screenSize.height)
        backgroundTileMemory().update(repeating: 0x0, count: count)

        let objectPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
        objectPalettes.update(repeating: 0, count: 256)
        Color.allGray.enumerated().forEach { index, color in
            objectPalettes[index + 1] = color.rawValue
        }
        objectAttributeMemory().update(repeating: ObjectAttribute(attr0: 0x0200), count: 128)
    }

    func waitForVSync() {
        let threshold = screenSize.height
        while verticalCount.load() >= threshold {}
        while verticalCount.load() < threshold {}
    }

    @inline(never)
    private func backgroundTileMemory() -> UnsafeMutablePointer<UInt16> {
        UnsafeMutablePointer<UInt16>(bitPattern: 0x06008000)!
    }

    func set(backgroundTiles: [UInt32]) {
        let pointer = UnsafeMutablePointer<UInt32>(bitPattern: 0x06000000)!
        pointer.update(from: backgroundTiles, count: backgroundTiles.count)
    }

    @inline(never)
    private func objectAttributeMemory() -> UnsafeMutablePointer<ObjectAttribute> {
        UnsafeMutablePointer<ObjectAttribute>(bitPattern: 0x07000000)!
    }

    func set(objectTiles: [UInt32]) {
        let pointer = UnsafeMutablePointer<UInt32>(bitPattern: 0x06010000)!
        pointer.update(from: objectTiles, count: objectTiles.count)
    }

    func update(sprites: [ObjectAttribute]) {
        sprites.indices.forEach { index in
            objectAttributeMemory()[index] = sprites[index]
        }
    }
}
