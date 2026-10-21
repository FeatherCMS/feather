import UserDomain
import UserModule

actor MockAuthIdentityRepository: Identity.Repository.Interface {
    private let identity: Identity.Model?

    init(identity: Identity.Model? = nil) {
        self.identity = identity
    }

    func findBy(id: String) async throws -> Identity.Model? { identity }
    func findRoot() async throws -> Identity.Model? { nil }
    func findRoleIdsBy(identityId: String) async throws -> [String] { [] }
    func replaceRoleIds(identityId: String, roleIds: [String]) async throws {}
    func insert(_ model: Identity.Model.New) async throws -> Identity.Model {
        fatalError("not needed")
    }
    func update(_ model: Identity.Model) async throws -> Identity.Model {
        model
    }
    func delete(ids: [String]) async throws -> [String] { [] }
}
