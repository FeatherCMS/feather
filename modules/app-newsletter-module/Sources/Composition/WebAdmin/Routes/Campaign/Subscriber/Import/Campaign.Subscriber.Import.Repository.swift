import NewsletterModule

extension Campaign.Subscriber.Import {
    enum Repository {}
}

extension Campaign.Subscriber.Import.Repository {
    protocol Interface: Sendable {
        func existingEmails(newsletterId: String) async throws -> Set<String>

        func create(
            newsletterId: String,
            record: Campaign.Subscriber.Import.CSVParser.Record
        ) async throws
    }
}
