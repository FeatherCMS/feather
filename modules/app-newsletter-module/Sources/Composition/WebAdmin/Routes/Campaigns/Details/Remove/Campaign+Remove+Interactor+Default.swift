import NewsletterApplication
import NewsletterModule

extension Campaign.Remove.Interactor {
    struct Default: Interface {
        let repository: Campaign.Remove.Repository.OpenAPI

        func remove(id: String) async throws {
            try await repository.remove(id: id)
        }

        func remove(ids: [String]) async throws {
            try await repository.remove(ids: ids)
        }
    }
}
