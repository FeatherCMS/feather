public import AuthModule
public import FeatherDomain

extension Credential.Repository {

    public protocol Interface: FeatherDomain.Repository {

        func findBy(
            id: String
        ) async throws -> Credential.Model?

        func findBy(
            userId: String
        ) async throws -> Credential.Model?

        func findBy(
            email: String
        ) async throws -> Credential.Model?

        func insert(
            _ model: Credential.Model.New
        ) async throws -> Credential.Model

        func update(
            _ model: Credential.Model
        ) async throws -> Credential.Model

        func delete(
            ids: [String]
        ) async throws -> [String]
    }

}
