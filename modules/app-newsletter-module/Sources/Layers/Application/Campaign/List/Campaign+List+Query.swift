public import NewsletterDomain
public import NewsletterModule

extension Campaign.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> [Campaign.Model]
        }
    }
}
