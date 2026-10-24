import NewsletterModule

extension Campaign.Add.Repository {
    protocol Interface: Sendable {
        func createNewsletter(
            key: String,
            name: String,
            fromEmail: String
        ) async throws
    }
}

extension Campaign.Add {
    enum Repository {}
}
