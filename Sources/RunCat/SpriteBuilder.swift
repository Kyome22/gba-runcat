struct SpriteBuilder {
    var backgroundTileData: [UInt32] {
        TileData.background
    }

    var objectTileData: [UInt32] {
        TileData.cat + TileData.road + TileData.number
    }

    private var offsettedRoadTileMap: [UInt16] {
        Road.tileMap.map { $0 + Cat.tileCount }
    }

    private var offsettedNumberTileMap: [UInt16] {
        let offset = Cat.tileCount + Road.tileCount
        return Number.tileMap.map { $0 + offset }
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

    func initialNumberSprites() -> [ObjectAttribute] {
        let characterNumber = offsettedNumberTileMap[0]
        return (UInt16.zero ..< 3).map { index in
            let numberOrigin = Number.tileOrigin + Point(x: 8 * index, y: 0)
            return ObjectAttribute(
                x: numberOrigin.x,
                y: numberOrigin.y,
                size: .size8x8,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func catCharacterNumber(of number: UInt8) -> UInt16 {
        Cat.tileMap[Int(number)]
    }

    func roadCharacterNumber(of number: UInt8) -> UInt16 {
        offsettedRoadTileMap[Int(number)]
    }

    func numberCharacterNumber(of number: UInt8) -> UInt16 {
        offsettedNumberTileMap[Int(number)]
    }
}
