import _Volatile

struct Timer {
    private let counter = VolatileMappedRegister<UInt16>(unsafeBitPattern: 0x4000100)
    private let control = UnsafeMutablePointer<UInt16>(bitPattern: 0x4000102)!
    private let targetCount: UInt16
    private var previousValue = UInt16.zero

    init(milliseconds: UInt16) {
        counter.store(.zero)
        previousValue = .zero
        control.pointee = 0x0002 | 0x0080

        let cpuFrequency: UInt32 = 0x1000000
        let prescalerDivisor: UInt32 = 0x0100
        let timerFrequency = cpuFrequency / prescalerDivisor
        let millisecondsPerSecond: UInt32 = 0x03E8
        let count = (UInt32(milliseconds) * timerFrequency) / millisecondsPerSecond
        targetCount = UInt16(count & 0xFFFF)
    }

    mutating func hasElapsed() -> Bool {
        let currentValue = counter.load()
        let elapsed: UInt16 = if currentValue < previousValue {
            (0xFFFF &- previousValue) &+ currentValue &+ 0x0001
        } else {
            currentValue &- previousValue
        }
        guard elapsed >= targetCount else {
            return false
        }
        previousValue = currentValue
        return true
    }

    mutating func reset() {
        previousValue = counter.load()
    }
}
