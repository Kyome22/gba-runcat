@main
struct GameEntry {
    static func main() {
        var frameCounter = UInt16.zero
        var lastKey = Key()
        var engine = Engine()
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()

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
        renderer.updateSprites(cat: catSprite, road: roadSprites, score: scoreSprites)

        while true {
            renderer.waitForVSync()

            let key = Key.poll()
            if key == .a, !lastKey.isPressingAnyKey {
                engine.send(.aKeyPressed)
            } else if key == [.select, .start], lastKey != [.select, .start] {
                engine.send(.selectAndStartKeysPressed)
            }
            lastKey = key

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
                    renderer.updateSprites(cat: catSprite, road: roadSprites, score: scoreSprites)
                }
            }
        }
    }
}
