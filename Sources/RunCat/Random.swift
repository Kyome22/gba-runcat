struct Random {
    private static nonisolated(unsafe) var seed: UInt32 = 1

    static func setSeed(_ value: UInt32) {
        seed = value
    }

    static func next() -> UInt32 {
        seed = seed &* 1103515245 &+ 12345
        return (seed >> 16) & 0x7FFF
    }

    static func next(upperBound: UInt32) -> UInt32 {
        next() % upperBound
    }

    static func nextUInt8(upperBound: UInt8) -> UInt8 {
        UInt8(next() % UInt32(upperBound))
    }
}
