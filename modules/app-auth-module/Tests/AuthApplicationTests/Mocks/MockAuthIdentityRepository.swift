import UserDomain
import UserModule

actor MockAuthIdentityRepository: Identity.Repository.Interface {
    private let identity: Identity.Model?

    init(identity: Identity.Model? = nil) {
        self.identity = identity
    }

    func findBy(id: String) async throws -> Identity.Model? { identity }
    func findRoot() async throws -> Identity.Model? { nil }
    func findRolesBy(identityId: String) async throws -> [String] { ["editor"] }
    func findRoleIdsBy(identityId: String) async throws -> [String] { [] }
    func findPermissionsBy(identityId: String) async throws -> [String] {
        ["account:read"]
    }
    func replaceRoleIds(identityId: String, roleIds: [String]) async throws {}
    func insert(_ model: Identity.Model.New) async throws -> Identity.Model {
        fatalError("not needed")
    }
    func update(_ model: Identity.Model) async throws -> Identity.Model {
        model
    }
    func delete(id: String) async throws -> Bool { false }
}
