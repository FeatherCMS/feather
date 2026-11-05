public import NewsModule

extension Category.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query) async throws -> Output
        }
    }
}
