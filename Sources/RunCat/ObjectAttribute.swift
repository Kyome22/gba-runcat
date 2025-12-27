enum SpriteSize: UInt16 {
    case size8x8 = 0x0000
    case size16x16 = 0x4000
    case size32x32 = 0x8000
    case size64x64 = 0xC000
}

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

    init(x: UInt16, y: UInt16, charNumber: UInt16, paletteNumber: UInt16, size: SpriteSize = .size8x8) {
        self.attr0 = (y & 0x00FF) | 0x0000
        self.attr1 = (x & 0x01FF) | size.rawValue
        self.attr2 = (charNumber & 0x03FF) | (paletteNumber << 12)
        self.attr3 = 0
    }

    var x: UInt16 {
        get { attr1 & 0x01ff }
        set { attr1 = (attr1 & 0xfe00) | (newValue & 0x01ff) }
    }

    var y: UInt16 {
        get { attr0 & 0x00ff }
        set { attr0 = (attr0 & 0xff00) | (newValue & 0x00ff) }
    }

    var charNumber: UInt16 {
        get { attr2 & 0x03ff }
        set { attr2 = (attr2 & 0xfc00) | (newValue & 0x03ff) }
    }

    var paletteNumber: UInt16 {
        get { attr2 >> 12 }
        set { attr2 = (attr2 & 0x0fff) | (newValue << 12) }
    }
}
