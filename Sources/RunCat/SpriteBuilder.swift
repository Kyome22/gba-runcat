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

    func createCatSprite(frameNamber: UInt8) -> ObjectAttribute {
        ObjectAttribute(
            x: Cat.tileOrigin.x,
            y: Cat.tileOrigin.y,
            size: .size32x32,
            characterNumber: Cat.tileMap[Int(frameNamber)],
            paletteNumber: 0
        )
    }

    func createRoadSprites(frameNumbers: [UInt8]) -> [ObjectAttribute] {
        let roadTileMap = offsettedRoadTileMap
        return frameNumbers.indices.map { index in
            let roadOrigin = Road.tileOrigin + Point(x: 8 * UInt16(index), y: 0)
            let characterNumber = roadTileMap[Int(frameNumbers[index])]
            return ObjectAttribute(
                x: roadOrigin.x,
                y: roadOrigin.y,
                size: .size8x16,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func createNumberSprites(frameNumbers: [UInt8]) -> [ObjectAttribute] {
        let numberTileMap = offsettedNumberTileMap
        return frameNumbers.indices.map { index in
            let numberOrigin = Number.tileOrigin + Point(x: 8 * UInt16(index), y: 0)
            let characterNumber = numberTileMap[Int(frameNumbers[index])]
            return ObjectAttribute(
                x: numberOrigin.x,
                y: numberOrigin.y,
                size: .size8x8,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func catCharacterNumber(of frameNumber: UInt8) -> UInt16 {
        Cat.tileMap[Int(frameNumber)]
    }

    func roadCharacterNumbers(of frameNumbers: [UInt8]) -> [UInt16] {
        let roadTileMap = offsettedRoadTileMap
        return frameNumbers.map { roadTileMap[Int($0)] }
    }

    func numberCharacterNumbers(of frameNumbers: [UInt8]) -> [UInt16] {
        let numberTileMap = offsettedNumberTileMap
        return frameNumbers.map { numberTileMap[Int($0)] }
    }
}
