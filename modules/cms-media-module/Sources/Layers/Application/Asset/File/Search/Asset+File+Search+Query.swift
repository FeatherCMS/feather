public import MediaModule

extension Asset.File.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Input.Query) async throws
                -> Output
        }
    }
}
