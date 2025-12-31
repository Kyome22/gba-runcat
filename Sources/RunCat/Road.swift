enum Road: UInt8 {
    case flat
    case hill
    case crater
    case sprout

    var frameNumber: UInt8 {
        rawValue
    }

    static let tileOrigin = Point(x: 0, y: 88)
    static let tileMap: [UInt16] = [0_, 8_, 16, 24]
    static let tileCount: UInt16 = 32
}
