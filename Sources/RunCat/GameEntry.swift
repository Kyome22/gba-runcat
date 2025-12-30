@main
struct GameEntry {
    static func main() {
        // var lastKey = Key()
        var engine = Engine(onGameOver: { _ in })
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        var timer = Timer(milliseconds: 100)

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        var catSprites = spriteBuilder.initialCatSprites()
        var roadSprites = spriteBuilder.initialRoadSprites()
        renderer.update(sprites: catSprites + roadSprites)

        engine.send(.gameLaunched)

        while true {
            renderer.waitForVSync()

            if timer.hasElapsed() {
                engine.send(.timeElapsed)

                spriteBuilder.catTileMap(of: engine.cat.frameNumber).enumerated().forEach { index, characterNumber in
                    catSprites[index].characterNumber = characterNumber
                }
                engine.roads.enumerated().forEach { block, road in
                    spriteBuilder.roadTileMap(of: road.frameNumber).enumerated().forEach { index, characterNumber in
                        roadSprites[2 * block + index].characterNumber = characterNumber
                    }
                }
                renderer.update(sprites: catSprites + roadSprites)
            }

            // let key = Key.poll()
            // if key.contains(.a), !lastKey.contains(.a) {
            //     engine.send(.keyPressed)
            // }
            // lastKey = key
        }
    }
}
