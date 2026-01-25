enum Letter: UInt8 {
    case space
    case period
    case colon
    case a
    case b
    case c
    case d
    case e
    case f
    case g
    case h
    case i
    case j
    case k
    case l
    case m
    case n
    case o
    case p
    case q
    case r
    case s
    case t
    case u
    case v
    case w
    case x
    case y
    case z

    static let tileMap: [UInt16] = (0 ..< 29).map { $0 }
    static let tileCount: UInt16 = 29
}
