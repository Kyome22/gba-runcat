import CoreGraphics
import Foundation

enum Number: Int, CaseIterable {
    case d0
    case d1
    case d2
    case d3
    case d4
    case d5
    case d6
    case d7
    case d8
    case d9

    var image: CGImage {
        CGImage.create(name: "number-\(rawValue)", bundle: .module)!
    }
}
