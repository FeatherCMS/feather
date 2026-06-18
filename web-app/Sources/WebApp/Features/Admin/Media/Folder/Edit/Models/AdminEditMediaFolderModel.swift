struct AdminEditMediaFolderModel: Sendable {
    let id: String
    let parentId: String?
    let name: String
    let path: String
    let assetCount: Int
    let totalSizeBytes: Int64
    let error: String?
}
