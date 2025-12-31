struct Size {
    var width: UInt16
    var height: UInt16

    var area: Int {
        Int(width * height)
    }
}
