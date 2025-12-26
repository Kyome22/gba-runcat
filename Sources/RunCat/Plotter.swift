import _Volatile

struct Plotter {
    private var vcount = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x4000006)
    private var screenSize = Size.screen

    init() {}

    func set(mode: UInt16, flags: UInt16) {
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x04000000)!
        displayControl.pointee = (mode & 0x0007) | (flags & 0xfff8)
    }

    // @inline(never)
    // private func vcount() -> UInt16 {
    //     let REG_VCOUNT = UnsafePointer<UInt16>(bitPattern: 0x04000006)!
    //     return REG_VCOUNT.pointee
    // }

    func waitForVSync() {
        let threshold = screenSize.height
        while vcount.load() >= threshold {}
        while vcount.load() < threshold {}
    }
}
