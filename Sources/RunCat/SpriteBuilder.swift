struct SpriteBuilder {
    var backgroundTileData: [UInt32] {
        TileData.background
    }

    var objectTileData: [UInt32] {
        TileData.cat + TileData.road + TileData.number + TileData.letter
    }

    private var offsettedRoadTileMap: [UInt16] {
        Road.tileMap.map { $0 + Cat.tileCount }
    }

    private var offsettedNumberTileMap: [UInt16] {
        let offset = Cat.tileCount + Road.tileCount
        return Number.tileMap.map { $0 + offset }
    }

    private func offsettedLetterTileMap(_ tileMap: [UInt16]) -> [UInt16] {
        let offset = Cat.tileCount + Road.tileCount + Number.tileCount
        return tileMap.map { $0 + offset }
    }

    func createCatSprite(origin: Point, frameNamber: UInt8) -> ObjectAttribute {
        ObjectAttribute(
            x: origin.x,
            y: origin.y,
            size: .size32x32,
            characterNumber: Cat.tileMap[Int(frameNamber)],
            paletteNumber: 0
        )
    }

    func createRoadSprites(origin: Point, frameNumbers: [UInt8]) -> [ObjectAttribute] {
        let roadTileMap = offsettedRoadTileMap
        return frameNumbers.indices.map { index in
            let offsettedOrigin = origin + Point(x: 8 * UInt16(index), y: 0)
            let characterNumber = roadTileMap[Int(frameNumbers[index])]
            return ObjectAttribute(
                x: offsettedOrigin.x,
                y: offsettedOrigin.y,
                size: .size8x16,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func createNumberSprites(origin: Point, frameNumbers: [UInt8]) -> [ObjectAttribute] {
        let numberTileMap = offsettedNumberTileMap
        return frameNumbers.indices.map { index in
            let offsettedOrigin = origin + Point(x: 8 * UInt16(index), y: 0)
            let characterNumber = numberTileMap[Int(frameNumbers[index])]
            return ObjectAttribute(
                x: offsettedOrigin.x,
                y: offsettedOrigin.y,
                size: .size8x8,
                characterNumber: characterNumber,
                paletteNumber: 0
            )
        }
    }

    func createSentenceSprite(sentence: Sentence, visibility: Bool) -> [ObjectAttribute] {
        let origin = sentence.origin
        let letterTileMap = offsettedLetterTileMap(sentence.tileMap)
        return letterTileMap.indices.map { index in
            let offsettedOrigin = origin + Point(x: 6 * UInt16(index), y: 0)
            let characterNumber = letterTileMap[index]
            return ObjectAttribute(
                x: offsettedOrigin.x,
                y: offsettedOrigin.y,
                size: .size8x8,
                characterNumber: characterNumber,
                paletteNumber: 0,
                visibility: visibility
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
