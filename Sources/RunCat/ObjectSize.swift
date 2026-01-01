enum ObjectSize {
    case size8x8
    case size8x16
    case size32x32

    var attr0: UInt16 {
        switch self {
        case .size8x8:   0x0000 // 0 square
        case .size8x16:  0x8000 // 2 vertical
        case .size32x32: 0x0000 // 0 square
        }
    }

    var attr1: UInt16 {
        switch self {
        case .size8x8:   0x0000 // 0
        case .size8x16:  0x0000 // 0
        case .size32x32: 0x8000 // 2
        }
    }
}
