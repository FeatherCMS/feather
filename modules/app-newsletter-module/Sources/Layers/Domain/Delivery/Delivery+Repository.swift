public import FeatherDomain
public import NewsletterModule

extension Delivery {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func list(
                issueId: String
            ) async throws -> [Model]

            func findBy(
                issueId: String,
                subscriberEmail: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                issueId: String
            ) async throws
        }
    }
}
