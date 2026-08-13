import FeatherContracts

public struct PermissionSeedDefinition: Sendable, Hashable, Codable {
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

    public init(
        permission: PermissionKey,
        notes: String? = nil
    ) {
        self.init(
            id: permission.rawValue,
            name: permission.rawValue,
            notes: notes ?? permission.rawValue
        )
    }
}
