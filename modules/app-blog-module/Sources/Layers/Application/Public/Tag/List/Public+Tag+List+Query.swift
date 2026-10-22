public import BlogModule

extension Public.Tag.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(query: Tag.Search.Input.Query) async throws
                -> Tag.List.Output
        }
    }
}
