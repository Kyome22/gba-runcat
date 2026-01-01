struct ObjectAttribute {
    var attr0: UInt16
    var attr1: UInt16
    var attr2: UInt16
    var attr3: UInt16

    init(attr0: UInt16 = 0, attr1: UInt16 = 0, attr2: UInt16 = 0, attr3: UInt16 = 0) {
        self.attr0 = attr0
        self.attr1 = attr1
        self.attr2 = attr2
        self.attr3 = attr3
    }

    init(x: UInt16, y: UInt16, size: ObjectSize, characterNumber: UInt16, paletteNumber: UInt16, visibility: Bool = true) {
        self.attr0 = (y & 0x00FF) | size.attr0 | (visibility ? 0 : 0x0200)
        self.attr1 = (x & 0x01FF) | size.attr1
        self.attr2 = (characterNumber & 0x03FF) | (paletteNumber << 12)
        self.attr3 = 0
    }

    var x: UInt16 {
        get { attr1 & 0x01FF }
        set { attr1 = (attr1 & 0xFE00) | (newValue & 0x01FF) }
    }

    var y: UInt16 {
        get { attr0 & 0x00FF }
        set { attr0 = (attr0 & 0xFF00) | (newValue & 0x00FF) }
    }

    var characterNumber: UInt16 {
        get { attr2 & 0x03FF }
        set { attr2 = (attr2 & 0xFC00) | (newValue & 0x03FF) }
    }

    var paletteNumber: UInt16 {
        get { attr2 >> 12 }
        set { attr2 = (attr2 & 0x0FFF) | (newValue << 12) }
    }

    mutating func set(visibility: Bool) {
        if visibility {
            attr0 &= ~0x0200
        } else {
            attr0 |= 0x0200
        }
    }
}
