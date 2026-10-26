import NewsletterModule

extension Subscriber.View.Interactor {
    struct Default: Interface {
        let repository: any Subscriber.View.Repository.Interface

        func get(id: String) async throws -> Subscriber.View.Model {
            try await repository.get(id: id)
        }
    }
}
