import ArgumentParser
import Foundation

struct Entrance: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ic",
        abstract: "A tool to convert image for sprite tile data of GBA.",
        version: "1.0.0"
    )

    mutating func run() throws {
        try ImageConverter().run()
    }
}

Entrance.main()
