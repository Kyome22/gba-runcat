enum Number: UInt8 {
    case d0
    case d1
    case d2
    case d3
    case d4
    case d5
    case d6
    case d7
    case d8
    case d9

    var frameNumber: UInt8 {
        rawValue
    }

    static let tileOrigin = Point(x: 8, y: 8)
    static let tileMap: [UInt16] = [0_, 1_, 2_, 3_, 4_, 5_, 6_, 7_, 8_, 9_]
    static let tileCount: UInt16 = 10
}
