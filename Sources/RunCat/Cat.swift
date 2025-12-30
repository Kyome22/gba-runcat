enum Cat {
    case running(Running)
    case jumping(Jumping)

    var violationIndices: [UInt8] {
        switch self {
        case let .running(value):
            value.violationIndices
        case let .jumping(value):
            value.violationIndices
        }
    }

    var frameNumber: UInt8 {
        switch self {
        case let .running(value):
            value.rawValue
        case let .jumping(value):
            5 + value.rawValue
        }
    }

    func next() -> Cat {
        switch self {
        case let .running(value):
            Cat.running(value.next())
        case let .jumping(value):
            Cat.jumping(value.next())
        }
    }
}

extension Cat {
    enum Running: UInt8 {
        case frame0
        case frame1
        case frame2
        case frame3
        case frame4

        var violationIndices: [UInt8] {
            switch self {
            case .frame0: [3, 4, 5]
            case .frame1: [3, 4]
            case .frame2: [3, 4]
            case .frame3: [3]
            case .frame4: [3, 5]
            }
        }

        func next() -> Running {
            Running(rawValue: (rawValue + 1) % 5)!
        }
    }
}

extension Cat {
    enum Jumping: UInt8 {
        case frame0
        case frame1
        case frame2
        case frame3
        case frame4
        case frame5
        case frame6
        case frame7
        case frame8
        case frame9

        var violationIndices: [UInt8] {
            switch self {
            case .frame0: [3, 4, 5]
            case .frame1: [3, 4]
            case .frame2: [3, 4]
            case .frame3: [3, 4]
            case .frame4: [3, 4]
            case .frame5: [3]
            case .frame6: []
            case .frame7: []
            case .frame8: []
            case .frame9: [5]
            }
        }

        func next() -> Jumping {
            Jumping(rawValue: (rawValue + 1) % 10)!
        }
    }
}
