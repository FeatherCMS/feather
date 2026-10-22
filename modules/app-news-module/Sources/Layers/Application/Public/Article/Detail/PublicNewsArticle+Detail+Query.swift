public import NewsModule

extension PublicNewsArticle.Detail {
    public enum Query {
        public protocol Interface: Sendable {
            func findCategories(ids: [String]) async throws -> Output
        }
    }
}
