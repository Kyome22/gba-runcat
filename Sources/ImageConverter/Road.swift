import CoreGraphics
import Foundation

enum Road: String, CaseIterable {
    case flat
    case hill
    case crater
    case sprout

    var image: CGImage {
        CGImage.create(name: "road-\(rawValue)", bundle: .module)!
    }

    var number: Int {
        switch self {
        case .flat: 0
        case .hill: 1
        case .crater: 2
        case .sprout: 3
        }
    }
}
