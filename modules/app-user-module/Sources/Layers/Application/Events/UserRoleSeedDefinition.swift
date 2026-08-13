public struct UserRoleSeedDefinition: Sendable, Hashable, Codable {
    public let id: String
    public let name: String?
    public let notes: String?

    public init(
        id: String,
        name: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.notes = notes
    }
}
