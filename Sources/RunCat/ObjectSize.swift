enum ObjectSize {
    case size8x8
    case size16x32
    case size64x64

    var attr0: UInt16 {
        switch self {
        case .size8x8:   0x0000 // 0 square
        case .size16x32: 0x8000 // 2 vertical
        case .size64x64: 0x0000 // 0 square
        }
    }

    var attr1: UInt16 {
        switch self {
        case .size8x8:   0x0000 // 0
        case .size16x32: 0x8000 // 2
        case .size64x64: 0xC000 // 3
        }
    }
}
