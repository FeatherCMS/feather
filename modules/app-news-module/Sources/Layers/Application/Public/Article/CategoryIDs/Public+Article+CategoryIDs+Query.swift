extension Public.Article.CategoryIDs {
    public enum Query {
        public protocol Interface: Sendable {
            func categoryIDs(for articleIDs: [String]) async throws -> [String:
                [String]]
        }
    }
}
