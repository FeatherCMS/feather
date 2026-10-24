public import MediaModule

extension Asset.File.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Asset.File.Search.Input.Query) async throws
                -> Asset.File.Search.Output
        }
    }
}
