import CoreGraphics
import Foundation

enum Cat {
    case running(RunningCat)
    case jumping(JumpingCat)

    var image: CGImage {
        switch self {
        case let .running(value): value.image
        case let .jumping(value): value.image
        }
    }
}

extension Cat {
    enum RunningCat: Int, CaseIterable {
        case frame0
        case frame1
        case frame2
        case frame3
        case frame4

        var image: CGImage {
            CGImage.create(name: "cat-running-\(rawValue)", bundle: .module)!
        }
    }
}

extension Cat {
    enum JumpingCat: Int, CaseIterable {
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

        var image: CGImage {
            CGImage.create(name: "cat-jamping-\(rawValue)", bundle: .module)!
        }
    }
}
