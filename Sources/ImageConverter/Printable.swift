import CoreGraphics

protocol Printable: CaseIterable {
    var image: CGImage { get }
}
