import UserDomain
import UserModule

actor MockIdentityRepository: Identity.Repository.Interface {
    private(set) var updateCallCount = 0
    private(set) var replaceRoleIdsCallCount = 0
    private(set) var replacedRoleIds: [String] = []
    private let identity: Identity.Model

    init(identity: Identity.Model) {
        self.identity = identity
    }

    func findBy(id: String) async throws -> Identity.Model? {
        id == identity.id ? identity : nil
    }

    func findRoot() async throws -> Identity.Model? { nil }

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

    func insert(_ model: Identity.Model.New) async throws -> Identity.Model {
        identity
    }

    func update(_ model: Identity.Model) async throws -> Identity.Model {
        updateCallCount += 1
        return model
    }

    func delete(ids: [String]) async throws -> [String] { [] }
}
