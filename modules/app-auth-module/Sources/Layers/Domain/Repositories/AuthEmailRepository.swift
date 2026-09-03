import FeatherDomain

public protocol AuthEmailRepository: Repository {
    func list() async throws -> [AuthEmail]
    func findBy(id: String) async throws -> AuthEmail?
    func findBy(email: String) async throws -> AuthEmail?
    func insert(identityId: String, email: String) async throws -> AuthEmail
    func update(_ model: AuthEmail) async throws -> AuthEmail
    func delete(ids: [String]) async throws -> [String]
}
