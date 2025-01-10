@main
struct EntryPoint {
    static func main() {
        let plotter = Plotter()
        plotter.set(mode: 3, flags: 0)
        plotter.cover(color: .white)
        plotter.set(mode: 3, flags: UInt16(1 << 10))
        var n = 0
        while true {
            (0 ..< 5).forEach { _ in
                plotter.waitForVSync()
            }
            let colors = switch n {
            case 0: Cat.page0.map { Color(black: $0) }
            case 1: Cat.page1.map { Color(black: $0) }
            case 2: Cat.page2.map { Color(black: $0) }
            case 3: Cat.page3.map { Color(black: $0) }
            case 4: Cat.page4.map { Color(black: $0) }
            default: fatalError()
            }
            plotter.draw(colors: colors, size: .init(width: 56, height: 36))
            n += 1
            if n == 5 {
                n = 0
            }
        }
    }
}
