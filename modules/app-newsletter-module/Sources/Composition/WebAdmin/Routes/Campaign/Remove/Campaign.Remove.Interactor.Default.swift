import NewsletterApplication
import NewsletterModule

extension Campaign.Remove.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Remove.Repository.Interface

        func remove(id: String) async throws {
            try await repository.remove(id: id)
        }

        func remove(ids: [String]) async throws {
            try await repository.remove(ids: ids)
        }
    }
}
