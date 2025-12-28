enum Color: Int {
    case c0 // transparent
    case c1
    case c2
    case c3
    case c4
    case c5
    case c6
    case c7

    init(value: UInt8) {
        self.init(rawValue: Int(value / 32))!
    }
}
