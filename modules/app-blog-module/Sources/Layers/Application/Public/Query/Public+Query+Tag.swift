public import BlogModule

extension Public.Query {
    public enum TagContent {
        public protocol Interface: Sendable {
            func find(id: String) async throws -> Tag.Detail.Output
            func list(query: Tag.Search.Input.Query) async throws
                -> Tag.List.Output
        }
    }
}
