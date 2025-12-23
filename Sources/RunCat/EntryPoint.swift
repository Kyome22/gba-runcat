@main
struct EntryPoint {
    static func main() {
        let plotter = Plotter()
        plotter.set(mode: 3, flags: UInt16(1 << 10))
        plotter.cover(color: .white)
        plotter.waitForVSync()

        var n = 0
        while true {
            let colors = Cat.pages[n].map { Color(black: $0) }
            plotter.draw(colors: colors, point: .init(x: 92, y: 62), size: .init(width: 56, height: 36))
            n += 1
            if n == 5 {
                n = 0
            }
            plotter.waitForVSync()
        }
    }
}
