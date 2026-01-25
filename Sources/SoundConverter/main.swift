import ArgumentParser
import Foundation

struct Entrance: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "sc",
        abstract: "A tool to convert WAV files to GBA PCM data.",
        version: "1.0.0"
    )

    @Argument(help: "Path to the WAV file")
    var path: String

    @Option(
        name: .shortAndLong,
        help: "Target sample rate (default: 16384)"
    )
    var sampleRate: Int = 16384

    mutating func run() throws {
        try SoundConverter(path: path, sampleRate: sampleRate).run()
    }
}

Entrance.main()
