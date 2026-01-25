enum SoundEffect {
    case jump
    case hit

    static let sampleRate: UInt16 = 16384

    var sampleCount: Int {
        switch self {
        case .jump:
            5976
        case .hit:
            15064
        }
    }

    var data: [Int8] {
        switch self {
        case .jump:
            SoundData.jump
        case .hit:
            SoundData.hit
        }
    }
}

// swift run sc "Sounds/jump.wav" --sample-rate 16384 2>/dev/null > Sources/RunCat/JumpSound.swift
// swift run sc "Sounds/hit.wav" --sample-rate 16384 2>/dev/null > Sources/RunCat/HitSound.swift
