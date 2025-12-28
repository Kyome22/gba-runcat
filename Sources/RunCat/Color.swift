enum Color: UInt16 {
    case background = 0x6318
    case gray1 = 0x56B5
    case gray2 = 0x4A52
    case gray3 = 0x3DEF
    case gray4 = 0x318C
    case gray5 = 0x2529
    case gray6 = 0x18C6
    case gray7 = 0x0C63
    case gray8 = 0x0000

    static let allGray: [Color] = [
        .gray1,
        .gray2,
        .gray3,
        .gray4,
        .gray5,
        .gray6,
        .gray7,
        .gray8,
    ]
}
