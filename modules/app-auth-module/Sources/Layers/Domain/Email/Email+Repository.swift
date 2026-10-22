public import AuthModule
public import FeatherDomain

extension Email.Repository {

    public protocol Interface: FeatherDomain.Repository {
        func list() async throws -> [Email.Model]
        func findBy(id: String) async throws -> Email.Model?
        func findBy(email: String) async throws -> Email.Model?
        func findBy(identityId: String) async throws -> Email.Model?
        func insert(identityId: String, email: String) async throws
            -> Email.Model
        func update(_ model: Email.Model) async throws
            -> Email.Model
        func delete(ids: [String]) async throws -> [String]
    }

}
