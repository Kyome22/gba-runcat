# Claude Code Configuration

## You Must

- Please respond in Japanese.

## You Must Not

- You must not read @Sources/RunCat/TileData.swift . The reason is that the file is huge and would consume too many tokens. The content consists of image data converted into a UInt32 array. The code structure is as follows.

  ```swift
  enum TileData {
      // MARK: Background
      static let background = [UInt32](repeating: 0, count: 8)

      // MARK: Cat
      static let cat: [UInt32] = [ /* omitted */ ]

      // MARK: Road
      static let road: [UInt32] = [ /* omitted */ ]

      // MARK: Number
      static let number: [UInt32] = [ /* omitted */ ]

      // MARK: Letter
      static let letter: [UInt32] = [ /* omitted */ ]
  }
  ```

- You must not read @Sources/RunCat/SoundData.swift . The reason is that the file is huge and would consume too many tokens. The content consists of sound data converted into a Int8 array. The code structure is as follows.

  ```swift
  enum SoundData {
      // MARK: Jump
      static let jump: [Int8] = [ /* omitted */ ]

      // MARK: Hit
      static let hit: [Int8] = [ /* omitted */ ]
  }
  ```

## Coding Rules

- Do not write comments within the source code.
- Use naming conventions that clearly indicate the purpose of the code, even without comments.
- In Swift code
  - Abbreviations such as URL or ID should be written in all lowercase or all uppercase (do not use Upper Camel Case for these prefixes).
  - Do not use abbreviations such as `img` for `image` or `cnt` for `count`.
