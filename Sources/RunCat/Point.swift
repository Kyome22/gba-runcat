struct Point {
    var x: UInt16
    var y: UInt16
}

func + (lhs: Point, rhs: Point) -> Point {
    Point(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
