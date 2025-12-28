@main
struct GameEntry {
    static func main() {
        var n = UInt8.zero
        var m = UInt8.zero
        let renderer = Renderer()
        let spriteBuilder = SpriteBuilder()
        var timer = Timer(milliseconds: 100)

        renderer.set(backgroundTiles: spriteBuilder.backgroundTileData)
        renderer.set(objectTiles: spriteBuilder.objectTileData)

        var sprites: [ObjectAttribute] = spriteBuilder.initialCatSprites()
        sprites.append(contentsOf: spriteBuilder.initialRoadSprites())
        renderer.update(sprites: sprites)

        while true {
            renderer.waitForVSync()

            if timer.hasElapsed() {
                n = (n + 1) % 15
                spriteBuilder.enumeratedCatTileMap(of: n).forEach { index, characterNumber in
                    sprites[index].characterNumber = characterNumber
                }

                m = (m + 1) % 4
                spriteBuilder.enumeratedRoadTileMap(of: m).forEach { index, characterNumber in
                    sprites[index].characterNumber = characterNumber
                }

                renderer.update(sprites: sprites)
            }
        }
    }
}
