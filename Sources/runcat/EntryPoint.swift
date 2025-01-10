@main
struct EntryPoint {
    static func main() {
        let plotter = Plotter()
        plotter.set(mode: 3, flags: 0)
        plotter.cover(color: .white)
        plotter.set(mode: 3, flags: UInt16(1 << 10))

        let colors: [Color?] = Cat.pages[0].map { Color(black: $0) }
        plotter.draw(colors: colors, size: .init(width: 56, height: 36))

        var n = 0
        var m = 1
        while true {
            (0 ..< 5).forEach { _ in
                plotter.waitForVSync()
            }
            let before = Cat.pages[n]
            let after = Cat.pages[m]
            let colors = before.indices.map { i -> Color? in
                if before[i] == after[i] {
                    return nil
                } else {
                    return  Color(black: after[i])
                }
            }
            plotter.draw(colors: colors, size: .init(width: 56, height: 36))
            n += 1
            if n == 5 {
                n = 0
            }
            m += 1
            if m == 5 {
                m = 0
            }
        }
    }
}
