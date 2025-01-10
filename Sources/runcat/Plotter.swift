struct Plotter {
    private var vram = UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    private var screenSize = Size.screen

    init() {}

    func set(mode: UInt16, flags: UInt16) {
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000000)!
        displayControl.pointee = (mode & 0x0007) | (flags & 0xfff8)
    }

    func waitForVSync() {
        let threshold = UInt16(screenSize.height)
        while UnsafeMutablePointer<UInt16>(bitPattern: 0x4000006)!.pointee >= threshold {}
        while UnsafeMutablePointer<UInt16>(bitPattern: 0x4000006)!.pointee < threshold {}
    }

    func cover(color: Color) {
        let color16 = color.to16Bit()
        vram.update(repeating: color16, count: screenSize.width * screenSize.height)
    }

    func plot(color: Color, point: Point) {
        if (.zero ..< screenSize.width).contains(point.x) && (.zero ..< screenSize.height).contains(point.y) {
            vram.advanced(by: point.y * screenSize.width + point.x).pointee = color.to16Bit()
        }
    }

    func draw(color: Color, point: Point, size: Size) {
        let startX = max(point.x, .zero)
        let startY = max(point.y, .zero)
        let endX = min(point.x + size.width, screenSize.width)
        let endY = min(point.y + size.height, screenSize.height)
        guard startX < endX && startY < endY else { return }
        let color16 = color.to16Bit()
        (startY ..< endY).forEach { y in
            vram.advanced(by: y * screenSize.width + startX)
                .initialize(repeating: color16, count: endX - startX)
        }
    }

    func draw(colors: [Color], size: Size) {
        (.zero ..< size.height).forEach { y in
            (.zero ..< size.width).forEach { x in
                vram.advanced(by: y * screenSize.width + x).pointee = colors[y * size.width + x].to16Bit()
            }
        }
    }
}
