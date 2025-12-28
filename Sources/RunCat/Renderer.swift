import _Volatile

struct Renderer {
    private var screenSize = Size.screen
    private var verticalCount = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x4000006)

    init() {
        let mode = UInt16.zero
        // let isEnabledBackground0: UInt16 = 0x0100
        // let isEnabledObject: UInt16 = 0x1000
        // let flags = isEnabledBackground0 | isEnabledObject
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000000)!
        displayControl.pointee = (mode & 0x0007) | (UInt16(1 << 12) & 0xFFF8)

//        let backgroundControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000008)!
//        backgroundControl.pointee = 0x0008
//
//        let backgroundPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000000)!
//        backgroundPalettes.update(repeating: 0, count: 1)
//        backgroundPalettes[0] = Color(white: 25).to16Bit()
//        let count = Int(screenSize.width * screenSize.height)
//        backgroundTileMemory().update(repeating: 0x0, count: count)

        let objectPalettes = UnsafeMutablePointer<UInt16>(bitPattern: 0x05000200)!
        objectPalettes.update(repeating: 0, count: 256)
//        objectPalettes[1] = 0x1084
//        objectPalettes[2] = 0x2529
//        objectPalettes[3] = 0x35AD
//        objectPalettes[4] = 0x4A52
//        objectPalettes[5] = 0x56D6
//        objectPalettes[6] = 0x6F7B
//        objectPalettes[7] = 0x7FFF

        (1 ..< 8).forEach { index in
            let white = UInt8((index * 31) / 7)
            let value = Color(white: white).asUInt16()
            objectPalettes[index] = value
        }

        objectAttributeMemory().update(repeating: ObjectAttribute(attr0: 0x0200), count: 128)
    }

    func waitForVSync() {
        let threshold = screenSize.height
        while verticalCount.load() >= threshold {}
        while verticalCount.load() < threshold {}
    }

//    @inline(never)
//    private func backgroundTileMemory() -> UnsafeMutablePointer<UInt16> {
//        UnsafeMutablePointer<UInt16>(bitPattern: 0x06008000)!
//    }
//
//    func set(backgroundTiles: [UInt32]) {
//        let pointer = UnsafeMutablePointer<UInt32>(bitPattern: 0x06000000)!
//        pointer.update(from: backgroundTiles, count: backgroundTiles.count)
//    }

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
