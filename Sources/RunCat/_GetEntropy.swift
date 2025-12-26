@_cdecl("getentropy")
func getentropy(
    _ ptr: UnsafeMutablePointer<UInt8>,
    _ size: Int
) -> Int {
    ptr.update(repeating: .zero, count: size)
    return .zero
}
