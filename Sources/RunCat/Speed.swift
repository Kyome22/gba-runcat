enum Speed: UInt16 {
    case gear0 = 6
    case gear1 = 5
    case gear2 = 4
    case gear3 = 3
    case gear4 = 2

    func next() -> Speed {
        Speed(rawValue: max(rawValue - 1, 2))!
    }
}
