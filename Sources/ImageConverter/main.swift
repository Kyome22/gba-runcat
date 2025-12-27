import ArgumentParser
import Foundation

struct Entrance: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "ic",
        abstract: "A tool to convert image for sprite tile data of GBA.",
        version: "1.0.0"
    )

    @Option(
        name: .shortAndLong,
        help: "cat or road"
    )
    var kind: String

    @Option(
        name: .shortAndLong,
        help: "map or data"
    )
    var format: String

    mutating func run() throws {
        try ImageConverter(kind: kind, format: format).run()
    }
}

Entrance.main()
