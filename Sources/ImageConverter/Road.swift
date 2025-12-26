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
}
