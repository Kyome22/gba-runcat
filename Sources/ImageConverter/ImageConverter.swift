import Foundation

struct ImageConverter {
    func run() throws {
        let image = Cat.running(.frame0).image
        print(image.size)
    }
}
