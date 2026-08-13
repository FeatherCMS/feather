public struct VariableSeedDefinition: Sendable, Hashable, Codable {
    public let id: String
    public let value: String
    public let name: String?
    public let notes: String?

    public init(
        id: String,
        value: String,
        name: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.value = value
        self.name = name
        self.notes = notes
    }
}
