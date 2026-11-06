public import AuthModule
public import FeatherDomain

extension Credential {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                id: String
            ) async throws -> Model?

            func findBy(
                userId: String
            ) async throws -> Model?

            func findBy(
                email: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                ids: [String]
            ) async throws -> [String]
        }
    }
}
