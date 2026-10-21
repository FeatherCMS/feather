public import AuthModule
public import FeatherDomain

extension AuthEmail.Repository {

    public protocol Interface: FeatherDomain.Repository {
        func list() async throws -> [AuthEmail.Model]
        func findBy(id: String) async throws -> AuthEmail.Model?
        func findBy(email: String) async throws -> AuthEmail.Model?
        func findBy(identityId: String) async throws -> AuthEmail.Model?
        func insert(identityId: String, email: String) async throws
            -> AuthEmail.Model
        func update(_ model: AuthEmail.Model) async throws
            -> AuthEmail.Model
        func delete(ids: [String]) async throws -> [String]
    }

}
