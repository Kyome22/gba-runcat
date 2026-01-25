import AVFoundation
import Foundation

struct SoundConverter {
    private let fileName: String
    private let audioFile: AVAudioFile
    private let sampleRate: Int

    init(path: String, sampleRate: Int) throws {
        let url = URL(fileURLWithPath: path)
        self.fileName = url.deletingPathExtension().lastPathComponent
        self.audioFile = try AVAudioFile(forReading: url)
        self.sampleRate = sampleRate
    }

    func run() {
        let (samples, actualSampleCount) = convert()
        printSwiftArray(samples: samples, actualSampleCount: actualSampleCount, fileName: fileName)
    }

    private func convert() -> (samples: [Int8], actualSampleCount: Int) {
        guard let buffer = readAudioBuffer() else {
            return ([], 0)
        }

        let floatSamples = extractFloatSamples(from: buffer)
        let resampledSamples = resample(samples: floatSamples)
        var samples = convertToSigned8Bit(samples: resampledSamples)
        let actualSampleCount = samples.count
        let paddingCount = 4096
        samples.append(contentsOf: [Int8](repeating: 0, count: paddingCount))
        return (samples, actualSampleCount)
    }

    private func readAudioBuffer() -> AVAudioPCMBuffer? {
        let format = audioFile.processingFormat
        let frameCount = AVAudioFrameCount(audioFile.length)

        guard let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else {
            return nil
        }

        do {
            try audioFile.read(into: buffer)
            return buffer
        } catch {
            return nil
        }
    }

    private func extractFloatSamples(from buffer: AVAudioPCMBuffer) -> [Float] {
        guard let channelData = buffer.floatChannelData else {
            return []
        }

        let frameLength = Int(buffer.frameLength)
        let channelCount = Int(buffer.format.channelCount)

        var samples = [Float](repeating: 0, count: frameLength)

        if channelCount == 1 {
            for i in 0..<frameLength {
                samples[i] = channelData[0][i]
            }
        } else {
            for i in 0..<frameLength {
                var sum: Float = 0
                for channel in 0..<channelCount {
                    sum += channelData[channel][i]
                }
                samples[i] = sum / Float(channelCount)
            }
        }

        return samples
    }

    private func resample(samples: [Float]) -> [Float] {
        let sourceSampleRate = audioFile.processingFormat.sampleRate
        let ratio = Double(sampleRate) / sourceSampleRate
        let targetLength = Int(Double(samples.count) * ratio)

        var resampled = [Float](repeating: 0, count: targetLength)

        for i in 0..<targetLength {
            let sourceIndex = Double(i) / ratio
            let lowerIndex = Int(sourceIndex)
            let upperIndex = min(lowerIndex + 1, samples.count - 1)
            let fraction = Float(sourceIndex - Double(lowerIndex))

            resampled[i] = samples[lowerIndex] * (1 - fraction) + samples[upperIndex] * fraction
        }

        return resampled
    }

    private func convertToSigned8Bit(samples: [Float]) -> [Int8] {
        return samples.map { sample in
            let clamped = max(-1.0, min(1.0, sample))
            let scaled = clamped * 127.0
            return Int8(clamping: Int(scaled))
        }
    }

    private func printSwiftArray(samples: [Int8], actualSampleCount: Int, fileName: String) {
        let capitalizedName = fileName.prefix(1).uppercased() + fileName.dropFirst()
        print("enum \(capitalizedName)Sound {")
        print("    static let sampleRate: UInt16 = \(sampleRate)")
        print("    static let sampleCount: Int = \(actualSampleCount)")
        print("    static let data: [Int8] = [")

        let chunkSize = 16
        for chunkStart in stride(from: 0, to: samples.count, by: chunkSize) {
            let chunkEnd = min(chunkStart + chunkSize, samples.count)
            let chunk = samples[chunkStart..<chunkEnd]
            let values = chunk.map { formatSample($0) }.joined(separator: ", ")
            print("        \(values),")
        }

        print("    ]")
        print("}")
    }

    private func formatSample(_ value: Int8) -> String {
        String(format: "%-3d", Int(value)).replacingOccurrences(of: " ", with: "_")
    }
}
