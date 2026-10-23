public import FeatherDomain
public import NewsletterModule

extension Campaign {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func findBy(
                id: String
            ) async throws -> Model?

            func findBy(
                key: String
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
