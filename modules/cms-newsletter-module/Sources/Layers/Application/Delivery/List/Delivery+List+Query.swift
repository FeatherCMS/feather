public import NewsletterModule

extension Delivery.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(input: Input) async throws -> Output
        }
    }
}
