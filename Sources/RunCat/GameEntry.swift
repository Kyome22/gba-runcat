@main
struct GameEntry {
    static func main() {
        var engine = Engine(onGameOver: { _ in })
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        var frameCounter = UInt16.zero

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        var catSprite = spriteBuilder.initialCatSprite()
        var roadSprites = spriteBuilder.initialRoadSprites()
        var numberSprites = spriteBuilder.initialNumberSprites()
        renderer.updateSprites(cat: catSprite, roads: roadSprites, numbers: numberSprites)

        engine.send(.gameLaunched)

        while true {
            renderer.waitForVSync()

            frameCounter &+= 1
            if frameCounter >= 6 {
                frameCounter = 0
                engine.send(.tickReceived)

                catSprite.characterNumber = spriteBuilder.catCharacterNumber(of: engine.cat.frameNumber)
                for (index, road) in engine.roads.enumerated() {
                    roadSprites[index].characterNumber = spriteBuilder.roadCharacterNumber(of: road.frameNumber)
                }
                let numbers = engine.number.digits(length: 3).map { Number(rawValue: $0)! }
                for (index, number) in numbers.enumerated() {
                    numberSprites[index].characterNumber = spriteBuilder.numberCharacterNumber(of: number.frameNumber)
                }
                renderer.updateSprites(cat: catSprite, roads: roadSprites, numbers: numberSprites)
            }

            // let key = Key.poll()
            // if key.contains(.a), !lastKey.contains(.a) {
            //     engine.send(.keyPressed)
            // }
            // lastKey = key
        }
    }
}
