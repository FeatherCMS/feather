public import NewsModule

extension Article.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list() async throws -> Output
        }
    }
}
