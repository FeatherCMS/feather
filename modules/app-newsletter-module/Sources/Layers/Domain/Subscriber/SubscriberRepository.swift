public import FeatherDomain
public import NewsletterModule

extension Subscriber {
    public enum Repository {
        public protocol Interface: FeatherDomain.Repository {

            func list(
                newsletterId: String
            ) async throws -> [Model]

            func findBy(
                newsletterId: String,
                email: String
            ) async throws -> Model?

            func insert(
                _ model: Model.New
            ) async throws -> Model

            func update(
                _ model: Model
            ) async throws -> Model

            func delete(
                newsletterId: String,
                emails: [String]
            ) async throws -> [String]
        }
    }
}
