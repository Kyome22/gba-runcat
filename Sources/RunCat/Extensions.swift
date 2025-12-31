extension Array {
    mutating func shift() {
        let c = count
        guard c > 1 else { return }
        let first = self[0]
        for index in 0 ..< c - 1 {
            self[index] = self[index + 1]
        }
        self[c - 1] = first
    }
}

extension Array where Element: Equatable {
    func hasCommonElements(with other: [Element]) -> Bool {
        for element in self {
            for otherElement in other {
                if element == otherElement {
                    return true
                }
            }
        }
        return false
    }
}

extension UInt16 {
    func digits(length: UInt8) -> [UInt8] {
        var result = [UInt8](repeating: 0, count: Int(length))
        var n = self
        for index in 1 ... length {
            result[Int(length - index)] = UInt8(n % 10)
            n /= 10
        }
        return result
    }
}
