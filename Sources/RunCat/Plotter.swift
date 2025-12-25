struct Plotter {
    private var screenSize = Size.screen

    init() {}

    func set(mode: UInt16, flags: UInt16) {
        let displayControl = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000000)!
        displayControl.pointee = (mode & 0x0007) | (flags & 0xfff8)
    }

    @inline(never)
    private func vcount() -> UInt16 {
        UnsafeMutablePointer<UInt16>(bitPattern: 0x4000006)!.pointee
    }

    func waitForVSync() {
        let threshold = UInt16(screenSize.height)
        while vcount() >= threshold {}
        while vcount() < threshold {}
    }

    @inline(never)
    private func vram() -> UnsafeMutablePointer<UInt16> {
        UnsafeMutablePointer<UInt16>(bitPattern: 0x6000000)!
    }

    func cover(color: Color) {
        let color16 = color.to16Bit()
        vram().update(repeating: color16, count: screenSize.width * screenSize.height)
    }

    func plot(color: Color, point: Point) {
        if (.zero ..< screenSize.width).contains(point.x) && (.zero ..< screenSize.height).contains(point.y) {
            vram().advanced(by: point.y * screenSize.width + point.x).pointee = color.to16Bit()
        }
    }

    func draw(color: Color, point: Point, size: Size) {
        guard size.width >= .zero && size.height >= .zero else { return }
        let startX = min(max(point.x, .zero), screenSize.width)
        let startY = min(max(point.y, .zero), screenSize.height)
        let endX = min(max(point.x + size.width, .zero), screenSize.width)
        let endY = min(max(point.y + size.height, .zero), screenSize.height)
        let color16 = color.to16Bit()
        (startY ..< endY).forEach { y in
            vram().advanced(by: y * screenSize.width + startX)
                .update(repeating: color16, count: endX - startX)
            // .initialize(repeating: color16, count: endX - startX)
        }
    }

    func draw(colors: [Color], point: Point, size: Size) {
        guard size.width >= .zero && size.height >= .zero else { return }

        let startX = min(max(point.x, .zero), screenSize.width)
        let startY = min(max(point.y, .zero), screenSize.height)
        let endX = min(max(point.x + size.width, .zero), screenSize.width)
        let endY = min(max(point.y + size.height, .zero), screenSize.height)

        let offsetX = max(-point.x, .zero)
        let offsetY = max(-point.y, .zero)

        let rangeX = endX - startX
        let rangeY = endY - startY

        (0 ..< rangeY).forEach { y in
            let anchor = (y + offsetY) * size.width + offsetX
            var values = colors[anchor ..< anchor + rangeX].map { $0.to16Bit() }
            vram().advanced(by: (y + startY) * screenSize.width + startX)
                .update(from: &values, count: rangeX)
        }
    }
}
