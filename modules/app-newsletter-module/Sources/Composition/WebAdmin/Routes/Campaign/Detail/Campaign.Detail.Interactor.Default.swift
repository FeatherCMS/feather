import NewsletterApplication
import NewsletterModule

extension Campaign.Detail.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Detail.Repository.Interface

        func get(id: String) async throws -> Campaign.Item {
            try await repository.get(id: id)
        }
    }
}
