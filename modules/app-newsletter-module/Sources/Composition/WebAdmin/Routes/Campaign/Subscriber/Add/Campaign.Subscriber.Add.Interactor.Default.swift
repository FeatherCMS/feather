import NewsletterModule

extension Campaign.Subscriber.Add.Interactor {
    struct Default: Interface {
        let repository: any Campaign.Subscriber.Add.Repository.Interface

        func create(
            newsletterId: String,
            form: Campaign.Subscriber.Form.Input
        ) async throws {
            try await repository.create(newsletterId: newsletterId, form: form)
        }
    }
}
