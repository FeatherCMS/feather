public import NewsletterModule

extension Issue.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(campaignKey: String) async throws -> Output
        }
    }
}
