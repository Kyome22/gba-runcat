struct Engine {
    static let JUMP_THRESHOLD: UInt8 = 14

    private var counter = UInt8.zero
    private var limit: UInt8 = 5
    private var isJumpRequested = false

    var status = Status.newGame
    var score = UInt8.zero
    var cat = Cat.running(.frame0)
    var roads = [Road](repeating: .sprout, count: 15)
    var onGameOver: (UInt8) -> Void
    var number = UInt16.zero

    init(onGameOver: @escaping (UInt8) -> Void) {
        self.onGameOver = onGameOver
    }

    mutating func send(_ action: Action) {
        switch action {
        case .gameLaunched:
            initialize()

        case .tickReceived:
//             guard judge() else { return }
            updateRoads()
            updateCat()
            number = (number + 1) % 1000

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

    private mutating func initialize() {
        counter = Self.JUMP_THRESHOLD
        isJumpRequested = false
        score = 0
        cat = .running(.frame0)
        for index in roads.indices {
            guard roads[index] == .sprout else { continue }
            roads[index] = Road(rawValue: Random.nextUInt8(upperBound: 3))!
        }
    }

//    private mutating func judge() -> Bool {
//        guard status == .playing else { return false }
//        let sproutIndices = roads.indices.compactMap { index in
//            roads[index] == .sprout ? UInt8(exactly: index) : nil
//        }
//        if cat.violationIndices.hasCommonElements(with: sproutIndices) {
//            status = .gameOver
//            if 0 < score {
//                onGameOver(score)
//            }
//            return false
//        } else {
//            return true
//        }
//    }

    private mutating func updateRoads() {
        if roads[0] == .sprout {
            // score += 1
            // if score.isMultiple(of: 10) {
            //     speed = max(speed - 0.01, 0.05)
            // }
        }
        roads.shift()
        roads[14] = Road(rawValue: Random.nextUInt8(upperBound: 3))!
        // counter = counter > 0 ? counter - 1 : limit - 1
        // // Sprout Chance
        // if counter == 0 {
        //     let randomValue = Int.random(in: 0 ..< 27)
        //     var subRoads = [Road]()
        //     if randomValue.isMultiple(of: 3) { // 1/3
        //         subRoads.append(Road.sprout)
        //     }
        //     if randomValue.isMultiple(of: 9) { // 1/9
        //         subRoads.append(Road.sprout)
        //     }
        //     if randomValue.isMultiple(of: 27) { // 1/27
        //         subRoads.append(Road.sprout)
        //     }
        //     roads.append(contentsOf: subRoads)
        //     limit = subRoads.isEmpty ? 5 : 10
        // }
    }

    private mutating func updateCat() {
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
        case tickReceived
        case keyPressed
    }
}
