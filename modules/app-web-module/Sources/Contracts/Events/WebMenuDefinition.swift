import FeatherContracts

public struct WebMenuDefinition: Sendable, Hashable, Codable {
    public let key: String
    public let name: String
    public let notes: String?

    public init(
        key: String,
        name: String,
        notes: String?
    ) {
        self.key = key
        self.name = name
        self.notes = notes
    }
}
