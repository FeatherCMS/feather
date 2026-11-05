extension String {
    public var emptyToNil: String? {
        isEmpty ? nil : self
    }
}
