import UserDomain

actor MockAuthIdentityRepository: IdentityRepository {
    private let identity: Identity?

    init(identity: Identity? = nil) {
        self.identity = identity
    }

    func findBy(id: String) async throws -> Identity? { identity }
    func findRoot() async throws -> Identity? { nil }
    func findRolesBy(identityId: String) async throws -> [String] { ["editor"] }
    func findRoleIdsBy(identityId: String) async throws -> [String] { [] }
    func findPermissionsBy(identityId: String) async throws -> [String] { ["account:read"] }
    func replaceRoleIds(identityId: String, roleIds: [String]) async throws {}
    func insert(_ model: Identity.New) async throws -> Identity { fatalError("not needed") }
    func update(_ model: Identity) async throws -> Identity { model }
    func delete(id: String) async throws -> Bool { false }
}
