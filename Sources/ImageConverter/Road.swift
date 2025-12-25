import AppKit

enum Road: String, CaseIterable {
    case flat
    case hill
    case crater
    case sprout

    var image: NSImage {
        NSImage(resource: .init(name: "road-\(rawValue)", bundle: .module))
    }
}
