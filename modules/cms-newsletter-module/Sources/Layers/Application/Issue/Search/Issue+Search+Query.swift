public import NewsletterModule

extension Issue.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(
                campaignKey: String,
                query: Input.Query
            ) async throws -> Output?
        }
    }
}
