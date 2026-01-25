@main
struct GameEntry {
    static func main() {
        var frameCounter = UInt16.zero
        var audioFrameCounter = UInt16.zero
        var lastButton = Button()
        var engine = Engine()
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        let audio = Audio()

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        engine.send(.gameLaunched)

        var catSprite = spriteBuilder.createCatSprite(
            origin: .init(x: 32, y: 80),
            frameNamber: engine.cat.frameNumber
        )
        var roadSprites = spriteBuilder.createRoadSprites(
            origin: .init(x: 0, y: 104),
            frameNumbers: engine.roadFrameNumbers
        )
        var scoreSprites = spriteBuilder.createNumberSprites(
            origin: .init(x: 208, y: 8),
            frameNumbers: engine.scoreFrameNumbers
        )
        var sentenceSprites: [[ObjectAttribute]] = [
            spriteBuilder.createSentenceSprite(sentence: .auto, visibility: engine.isAutoPlay),
            spriteBuilder.createSentenceSprite(sentence: .gameOver, visibility: engine.status == .gameOver),
            spriteBuilder.createSentenceSprite(sentence: .pressAToPlay, visibility: engine.status != .playing),
        ]
        renderer.updateSprites(
            cat: catSprite,
            road: roadSprites,
            score: scoreSprites,
            sentence: sentenceSprites.flatMap { $0 }
        )
        engine.onSoundEffect = {
            audioFrameCounter = audio.play(soundEffect: $0)
        }

        while true {
            renderer.waitForVSync()

            if audioFrameCounter > 0 {
                audioFrameCounter -= 1
                if audioFrameCounter == 0 {
                    audio.stop()
                }
            }

            let button = Button.poll()
            if button == .a, !lastButton.isPressingAnyButton {
                engine.send(.aButtonPressed)
            } else if button == [.select, .start], lastButton != [.select, .start] {
                engine.send(.selectAndStartButtonsPressed)
                for index in sentenceSprites[Sentence.auto.rawValue].indices {
                    sentenceSprites[Sentence.auto.rawValue][index].set(visibility: engine.isAutoPlay)
                }
                renderer.updateSprites(
                    cat: catSprite,
                    road: roadSprites,
                    score: scoreSprites,
                    sentence: sentenceSprites.flatMap { $0 }
                )
            }
            lastButton = button

            if engine.status == .playing {
                frameCounter &+= 1
                if frameCounter >= engine.speed.rawValue {
                    frameCounter = 0
                    engine.send(.tickReceived)

                    catSprite.characterNumber = spriteBuilder.catCharacterNumber(of: engine.cat.frameNumber)
                    for (index, characterNumber) in spriteBuilder.roadCharacterNumbers(of: engine.roadFrameNumbers).enumerated() {
                        roadSprites[index].characterNumber = characterNumber
                    }
                    for (index, characterNumber) in spriteBuilder.numberCharacterNumbers(of: engine.scoreFrameNumbers).enumerated() {
                        scoreSprites[index].characterNumber = characterNumber
                    }
                    for index in sentenceSprites[Sentence.gameOver.rawValue].indices {
                        sentenceSprites[Sentence.gameOver.rawValue][index].set(visibility: engine.status == .gameOver)
                    }
                    for index in sentenceSprites[Sentence.pressAToPlay.rawValue].indices {
                        sentenceSprites[Sentence.pressAToPlay.rawValue][index].set(visibility: engine.status != .playing)
                    }
                    renderer.updateSprites(
                        cat: catSprite,
                        road: roadSprites,
                        score: scoreSprites,
                        sentence: sentenceSprites.flatMap { $0 }
                    )
                }
            }
        }
    }
}
