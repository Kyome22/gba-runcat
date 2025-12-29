extension Collection where Element: Hashable {
    func hasCommonElements<C: Collection>(with other: C) -> Bool where C.Element == Element {
        return !Set(self).isDisjoint(with: other)
    }
}
