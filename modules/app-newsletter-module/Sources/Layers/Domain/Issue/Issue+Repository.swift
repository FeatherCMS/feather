public import FeatherDomain
public import NewsletterModule

extension Issue {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func list(
                newsletterId: String
            ) async throws -> [Model]

            func findBy(
                id: String
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
