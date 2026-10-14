public struct DatabaseIndexSchema: Sendable {
    public let name: String
    public let columns: [any DatabaseFieldRepresentable]
    public let isUnique: Bool

    public init(
        name: String,
        columns: [any DatabaseFieldRepresentable],
        isUnique: Bool = false
    ) {
        self.name = name
        self.columns = columns
        self.isUnique = isUnique
    }
}
