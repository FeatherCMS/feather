public struct UserRoleSeedDefinition: Sendable, Hashable, Codable {
    public let key: String
    public let name: String?
    public let notes: String?

    public init(
        key: String,
        name: String? = nil,
        notes: String? = nil
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }
}
