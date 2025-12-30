struct SpriteBuilder {
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

    private var offsettedRoadTileMap: [UInt16] {
        let offset = UInt16(Cat.tileData.count / 8)
        return Road.tileMap.map { $0 + offset }
    }

    func initialCatSprite() -> ObjectAttribute {
        ObjectAttribute(
            x: Cat.tileOrigin.x,
            y: Cat.tileOrigin.y,
            size: .size64x64,
            characterNumber: Cat.tileMap[0],
            paletteNumber: 0
        )
    }

    func initialRoadSprites() -> [ObjectAttribute] {
        let characterNumber = offsettedRoadTileMap[0]
        return (UInt16.zero ..< 15).map { index in
            let roadOrigin = Road.tileOrigin + Point(x: 16 * index, y: 0)
            return ObjectAttribute(
                x: roadOrigin.x,
                y: roadOrigin.y,
                size: .size16x32,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func catCharacterNumber(of number: UInt8) -> UInt16 {
        Cat.tileMap[Int(number)]
    }

    func roadCharacterNumbers(of numbers: [UInt8]) -> [UInt16] {
        let roadTileMap = offsettedRoadTileMap
        return numbers.map { roadTileMap[Int($0)] }
    }
}
