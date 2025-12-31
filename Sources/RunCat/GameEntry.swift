@main
struct GameEntry {
    static func main() {
        var lastKey = Key()
        var engine = Engine(onGameOver: { _ in })
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        var frameCounter = UInt16.zero

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        engine.send(.gameLaunched)

        var catSprite = spriteBuilder.createCatSprite(frameNamber: engine.cat.frameNumber)
        var roadSprites = spriteBuilder.createRoadSprites(frameNumbers: engine.roadFrameNumbers)
        var scoreSprites = spriteBuilder.createNumberSprites(frameNumbers: engine.scoreFrameNumbers)
        renderer.updateSprites(cat: catSprite, road: roadSprites, score: scoreSprites)

        while true {
            renderer.waitForVSync()

            let key = Key.poll()
            if key.contains(.a), !lastKey.contains(.a) {
                engine.send(.keyPressed)
            }
            lastKey = key

            if engine.status == .playing {
                frameCounter &+= 1
                if frameCounter >= 6 {
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
