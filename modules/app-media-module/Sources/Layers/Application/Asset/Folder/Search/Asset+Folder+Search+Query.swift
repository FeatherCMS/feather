public import MediaModule

extension Asset.Folder.Search {
    public enum Query {
        public protocol Interface: Sendable {
            func search(query: Asset.Folder.Search.Input.Query) async throws
                -> Asset.Folder.Search.Output
        }
    }
}
