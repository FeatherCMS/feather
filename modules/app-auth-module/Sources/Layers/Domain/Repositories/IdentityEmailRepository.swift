import FeatherDomain

public protocol IdentityEmailRepository: Repository {
    func list() async throws -> [IdentityEmail]
    func findBy(id: String) async throws -> IdentityEmail?
    func findBy(email: String) async throws -> IdentityEmail?
    func insert(identityId: String, email: String) async throws -> IdentityEmail
    func update(_ model: IdentityEmail) async throws -> IdentityEmail
    func delete(ids: [String]) async throws -> [String]
}
