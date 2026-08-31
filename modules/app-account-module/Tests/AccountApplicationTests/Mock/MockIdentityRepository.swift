import UserDomain

actor MockIdentityRepository: IdentityRepository {
    private(set) var updateCallCount = 0
    private(set) var replaceRoleIdsCallCount = 0
    private(set) var replacedRoleIds: [String] = []
    private let identity: Identity

    init(identity: Identity) {
        self.identity = identity
    }

    func findBy(id: String) async throws -> Identity? {
        id == identity.id ? identity : nil
    }

    func findRoot() async throws -> Identity? { nil }

    func findRolesBy(identityId: String) async throws -> [String] { [] }

    func findRoleIdsBy(identityId: String) async throws -> [String] { [] }

    func findPermissionsBy(identityId: String) async throws -> [String] { [] }

    func replaceRoleIds(
        identityId: String,
        roleIds: [String]
    ) async throws {
        replaceRoleIdsCallCount += 1
        replacedRoleIds = roleIds
    }

    func insert(_ model: Identity.New) async throws -> Identity { identity }

    func update(_ model: Identity) async throws -> Identity {
        updateCallCount += 1
        return model
    }

    func delete(id: String) async throws -> Bool { false }
}
