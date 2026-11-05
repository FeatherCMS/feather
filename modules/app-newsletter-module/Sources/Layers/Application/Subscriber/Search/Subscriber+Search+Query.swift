public import NewsletterModule

extension Subscriber.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query) async throws -> Output
        }
    }
}
