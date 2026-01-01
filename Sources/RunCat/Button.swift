struct Button: OptionSet {
    let rawValue: UInt16

    static let a      = Button(rawValue: 1 << 0)
    static let select = Button(rawValue: 1 << 2)
    static let start  = Button(rawValue: 1 << 3)
    static let all    = Button(rawValue: 0x03FF)

    static func poll() -> Self {
        let pointer = UnsafePointer<UInt16>(bitPattern: 0x04000130)!
        return Self(rawValue: ~pointer.pointee & Button.all.rawValue)
    }

    var isPressingAnyButton: Bool {
        rawValue != 0
    }
}
