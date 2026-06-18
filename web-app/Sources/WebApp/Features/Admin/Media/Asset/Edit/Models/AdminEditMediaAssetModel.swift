struct AdminEditMediaAssetModel: Sendable {
    let id: String
    let storageKey: String
    let type: String
    let status: String
    let sizeBytes: Int64
    let title: String
    let altText: String
    let error: String?
}
