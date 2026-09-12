import FeatherContracts

public struct PermissionSeedDefinition: Sendable, Hashable, Codable {
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

    public init(
        permission: PermissionKey,
        notes: String? = nil
    ) {
        self.init(
            key: permission.rawValue,
            name: permission.rawValue,
            notes: notes ?? permission.rawValue
        )
    }
}
