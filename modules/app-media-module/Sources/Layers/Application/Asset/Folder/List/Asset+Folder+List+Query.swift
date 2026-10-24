public import MediaModule

extension Asset.Folder.List {
    public enum Query {
        public protocol Interface: Sendable {
            func list(parentId: String?) async throws
                -> Asset.Folder.List.Output
        }
    }
}
