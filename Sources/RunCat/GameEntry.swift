@main
struct GameEntry {
    static func main() {
        // var lastKey = Key()
        var engine = Engine(onGameOver: { _ in })
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        var frameCounter: UInt16 = 0
        let frameThreshold: UInt16 = 6

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        var catSprite = spriteBuilder.initialCatSprite()
        var roadSprites = spriteBuilder.initialRoadSprites()
        renderer.update(sprites: [catSprite] + roadSprites)

        engine.send(.gameLaunched)

        while true {
            renderer.waitForVSync()

            frameCounter &+= 1
            if frameCounter >= frameThreshold {
                frameCounter = 0
                engine.send(.tickReceived)

                catSprite.characterNumber = spriteBuilder.catCharacterNumber(of: engine.cat.frameNumber)
                spriteBuilder.roadCharacterNumbers(of: engine.roads.map({ $0.frameNumber }))
                    .enumerated()
                    .forEach { index, characterNumber in
                        roadSprites[index].characterNumber = characterNumber
                    }
                renderer.update(sprites: [catSprite] + roadSprites)
            }

            // let key = Key.poll()
            // if key.contains(.a), !lastKey.contains(.a) {
            //     engine.send(.keyPressed)
            // }
            // lastKey = key
        }
    }
}
