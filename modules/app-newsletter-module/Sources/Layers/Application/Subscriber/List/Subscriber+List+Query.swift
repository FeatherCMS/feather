public import NewsletterModule

extension Subscriber.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(newsletterId: String) async throws -> Output
            func list(campaignKey: String) async throws -> Output
        }
    }
}
