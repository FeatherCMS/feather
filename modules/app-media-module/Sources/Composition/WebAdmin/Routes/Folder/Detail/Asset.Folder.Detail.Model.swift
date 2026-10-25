import MediaModule

extension Asset.Folder.Detail {
    struct Model: Sendable {
        let id: String
        let parentId: String?
        let name: String
        let slug: String
        let slugPath: String
        let assetCount: Int
        let totalSizeBytes: Int64
    }
}
