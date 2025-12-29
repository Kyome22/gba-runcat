@main
struct GameEntry {
    static func main() {
        //var lastKey = Key()
        //let engine = Engine(onGameOver: { _ in })
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        //var timer = Timer(milliseconds: 100)

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        var catSprites = spriteBuilder.initialCatSprites()
        renderer.update(sprites: catSprites, at: 0)

        var roadSprites = spriteBuilder.initialRoadSprites()
        renderer.update(sprites: roadSprites, at: catSprites.count)

        //engine.send(.gameLaunched)

        while true {
            renderer.waitForVSync()

                /*
            if timer.hasElapsed() {
                engine.send(.timeElapsed)

                // spriteBuilder.catTileMap(of: engine.cat.frameNumber).enumerated().forEach { index, characterNumber in
                //     catSprites[index].characterNumber = characterNumber
                // }
                // renderer.update(sprites: catSprites, at: 0)

                // m = (m + 1) % 4
                // spriteBuilder.roadTileMap(of: m).enumerated().forEach { index, characterNumber in
                //     roadSprites[index].characterNumber = characterNumber
                // }
                // renderer.update(sprites: roadSprites, at: catSprites.count)
            }

            let key = Key.poll()
            if key.contains(.a), !lastKey.contains(.a) {
                engine.send(.keyPressed)
            }
            lastKey = key
                 */
        }
    }
}
