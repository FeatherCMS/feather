public import NewsletterModule

extension Subscriber.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(campaignKey: String, email: String) async throws -> Output
        }
    }
}
