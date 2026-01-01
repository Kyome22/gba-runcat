enum Road: UInt8 {
    case flat
    case hill
    case crater
    case sprout

    var frameNumber: UInt8 {
        rawValue
    }

    static let tileMap: [UInt16] = [0, 2, 4, 6]
    static let tileCount: UInt16 = 8
}
