public import MediaModule

extension Variant.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query) async throws -> Output
        }
    }
}
