struct SpriteBuilder {
    private let catTileTotal: UInt16 = Cat.tileSize.width * Cat.tileSize.height
    private let roadTileTotal: UInt16 = Road.tileSize.width * Road.tileSize.height

    /* It means the same as what follows.
     [
         0x00000000,
         0x00000000,
         0x00000000,
         0x00000000,
         0x00000000,
         0x00000000,
         0x00000000,
         0x00000000,
     ]
    */
    var backgroundTileData: [UInt32] {
        Array(repeating: 0, count: 8)
    }

    var objectTileData: [UInt32] {
        Cat.tileData + Road.tileData
    }

    private var offsettedRoadTileMap: [[UInt16]] {
        let offset = UInt16(Cat.tileData.count / 8)
        return Road.tileMap.map { tiles in
            tiles.map { $0 + offset }
        }
    }

    // 168 (4 * 2 * 15) + (6 * 8)

    func initialCatSprites() -> [ObjectAttribute] {
        let catTileSize = Cat.tileSize
        let catOrigin = Cat.origin
        return (0 ..< catTileTotal).map { index in
            let characterNumber = Cat.tileMap[0][Int(index)]
            return ObjectAttribute(
                x: catOrigin.x + 8 * (index % catTileSize.width),
                y: catOrigin.y + 8 * (index / catTileSize.width),
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func initialRoadSprites() -> [ObjectAttribute] {
        let roadTileMap = offsettedRoadTileMap
        let roadTileSize = Road.tileSize
        return (UInt16.zero ..< 15).flatMap { block in
            let roadOrigin = Road.origin + Point(x: 16 * block, y: 0)
            return (0 ..< roadTileTotal).map { index in
                let characterNumber = roadTileMap[0][Int(index)]
                return ObjectAttribute(
                    x: roadOrigin.x + 8 * (index % roadTileSize.width),
                    y: roadOrigin.y + 8 * (index / roadTileSize.width),
                    characterNumber: characterNumber,
                    paletteNumber: 0
                )
            }
        }
    }

    func catTileMap(of number: UInt8) -> [UInt16] {
        Cat.tileMap[Int(number)]
    }

    func roadTileMap(of number: UInt8) -> [UInt16] {
        offsettedRoadTileMap[Int(number)]
    }
}
