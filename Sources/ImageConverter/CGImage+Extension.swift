import CoreGraphics
import Foundation
import ImageIO

extension CGImage {
    static func create(name: String, bundle: Bundle) -> CGImage? {
        guard let url = bundle.url(forResource: name, withExtension: "png"),
              let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            return nil
        }
        return CGImageSourceCreateImageAtIndex(imageSource, 0, nil)
    }
}
