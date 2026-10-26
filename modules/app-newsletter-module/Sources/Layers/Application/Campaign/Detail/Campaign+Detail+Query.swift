public import NewsletterModule

extension Campaign.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Output
            func find(key: String) async throws -> Output
        }
    }
}
