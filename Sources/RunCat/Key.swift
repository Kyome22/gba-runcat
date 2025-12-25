struct Key: OptionSet {
    let rawValue: UInt16

    static let a        = Key(rawValue: 1 << 0)
    static let b        = Key(rawValue: 1 << 1)
    static let select   = Key(rawValue: 1 << 2)
    static let start    = Key(rawValue: 1 << 3)
    static let right    = Key(rawValue: 1 << 4)
    static let left     = Key(rawValue: 1 << 5)
    static let up       = Key(rawValue: 1 << 6)
    static let down     = Key(rawValue: 1 << 7)
    static let r        = Key(rawValue: 1 << 8)
    static let l        = Key(rawValue: 1 << 9)

    static let all      = Key(rawValue: 0x03ff)

    static func poll() -> Self {
        let REG_KEYINPUT = UnsafePointer<UInt16>(bitPattern: 0x04000130)!
        return Self(rawValue: ~REG_KEYINPUT.pointee & 0x03ff)
    }

    var isPressingAnyKey: Bool {
        rawValue != 0
    }
}
