public import NewsletterModule

extension Issue.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(campaignKey: String, id: String) async throws -> Output
        }
    }
}
