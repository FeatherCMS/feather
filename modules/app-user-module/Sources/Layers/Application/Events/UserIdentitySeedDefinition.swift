public struct UserIdentitySeedDefinition: Sendable, Hashable, Codable {
    public let id: String
    public let status: UserIdentitySeedStatus
    public let isRoot: Bool
    public let roleIDs: [String]

    public init(
        id: String,
        status: UserIdentitySeedStatus = .active,
        isRoot: Bool = false,
        roleIDs: [String] = []
    ) {
        self.id = id
        self.status = status
        self.isRoot = isRoot
        self.roleIDs = roleIDs
    }
}
