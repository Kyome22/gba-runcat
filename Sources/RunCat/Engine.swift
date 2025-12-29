class Engine {
    static let JUMP_THRESHOLD: UInt8 = 14

    private var counter = UInt8.zero
    private var limit: UInt8 = 5
    private var isJumpRequested = false

    var status = Status.newGame
    var score = UInt8.zero
    var cat = Cat.running(.frame0)
    var roads = [Road]()
    let onGameOver: (UInt8) -> Void

    init(onGameOver: @escaping (UInt8) -> Void) {
        self.onGameOver = onGameOver
    }

    func send(_ action: Action) {
        switch action {
        case .gameLaunched:
            initialize()

        case .timeElapsed:
            guard judge() else { return }
            updateRoads()
            updateCat()

        case .keyPressed:
            switch status {
            case .newGame, .gameOver:
                initialize()
                status = .playing

            case .playing:
                isJumpRequested = true
            }
        }
    }

    private func initialize() {
        counter = Self.JUMP_THRESHOLD
        isJumpRequested = false
        score = 0
        cat = .running(.frame0)
        roads.removeAll { $0 == .sprout }
        (0 ..< 15 - roads.count).forEach { _ in
            roads.append(Road(rawValue: UInt8.random(in: 0 ..< 3))!)
        }
    }

    private func judge() -> Bool {
        guard status == .playing else { return false }
        let sproutIndices = roads.indices.compactMap { index in
            roads[index] == .sprout ? UInt8(exactly: index) : nil
        }
        if cat.violationIndices.hasCommonElements(with: sproutIndices) {
            status = .gameOver
            if 0 < score {
                onGameOver(score)
            }
            return false
        } else {
            return true
        }
    }

    private func updateRoads() {
        if roads.removeFirst() == .sprout {
            score += 1
            // if score.isMultiple(of: 10) {
            //     speed = max(speed - 0.01, 0.05)
            // }
        }
        counter = counter > 0 ? counter - 1 : limit - 1
        // Sprout Chance
        if counter == 0 {
            let randomValue = Int.random(in: 0 ..< 27)
            var subRoads = [Road]()
            if randomValue.isMultiple(of: 3) { // 1/3
                subRoads.append(Road.sprout)
            }
            if randomValue.isMultiple(of: 9) { // 1/9
                subRoads.append(Road.sprout)
            }
            if randomValue.isMultiple(of: 27) { // 1/27
                subRoads.append(Road.sprout)
            }
            roads.append(contentsOf: subRoads)
            limit = subRoads.isEmpty ? 5 : 10
        }
        if roads.count < 15 {
            roads.append(Road(rawValue: UInt8.random(in: 0 ..< 3))!)
        }
    }

    private func updateCat() {
        switch cat {
        case .running(.frame4) where isJumpRequested:
            cat = .jumping(.frame0)
            isJumpRequested = false
        case .jumping(.frame9) where isJumpRequested:
            cat = cat.next()
            isJumpRequested = false
        case .jumping(.frame9):
            cat = .running(.frame0)
        default:
            cat = cat.next()
        }
    }

    enum Action {
        case gameLaunched
        case timeElapsed
        case keyPressed
    }
}
