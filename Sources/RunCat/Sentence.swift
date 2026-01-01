enum Sentence {
    case auto
    case gameOver
    case pressAToPlay

    private var letters: [Letter] {
        switch self {
        case .auto:
            [.a, .u, .t, .o]
        case .gameOver:
            [.g, .a, .m, .e, .space, .o, .v, .e, .r]
        case .pressAToPlay:
            [.p, .r, .e, .s, .s, .space, .a, .space, .t, .o, .space, .p, .l, .a, .y, .period]
        }
    }

    var tileMap: [UInt16] {
        letters.map { UInt16($0.rawValue) }
    }

    var origin: Point {
        switch self {
        case .auto:
            Point(x: 8, y: 8)
        case .gameOver:
            Point(x: 93, y: 32)
        case .pressAToPlay:
            Point(x: 72, y: 48)
        }
    }
}
