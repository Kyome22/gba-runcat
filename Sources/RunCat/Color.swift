struct Color {
    var red: UInt8   // 0-31
    var green: UInt8 // 0-31
    var blue: UInt8  // 0-31

    init(red: UInt8, green: UInt8, blue: UInt8) {
        self.red = min(red, 31)
        self.green = min(green, 31)
        self.blue = min(blue, 31)
    }

    init(white: UInt8) {
        self.red = min(white, 31)
        self.green = min(white, 31)
        self.blue = min(white, 31)
    }

    init(black: UInt8) {
        self.red = 31 - min(black, 31)
        self.green = 31 - min(black, 31)
        self.blue = 31 - min(black, 31)
    }

    func to16Bit() -> UInt16 {
        (UInt16(red) & 0x1F) | (UInt16(green) & 0x1F) << 5 | (UInt16(blue) & 0x1F) << 10
    }
}
