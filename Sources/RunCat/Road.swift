enum Road: UInt8 {
    case flat
    case hill
    case crater
    case sprout

    var frameNumber: UInt8 {
        rawValue
    }
}
