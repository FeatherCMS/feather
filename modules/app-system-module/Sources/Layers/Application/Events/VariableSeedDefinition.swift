public struct VariableSeedDefinition: Sendable, Hashable, Codable {
    public let key: String
    public let value: String
    public let name: String?
    public let notes: String?

    public init(
        key: String,
        value: String,
        name: String? = nil,
        notes: String? = nil
    ) {
        self.key = key
        self.value = value
        self.name = name
        self.notes = notes
    }
}
