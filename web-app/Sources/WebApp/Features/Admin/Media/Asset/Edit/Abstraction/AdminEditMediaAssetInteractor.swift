protocol AdminEditMediaAssetInteractor: Sendable {
    func load(
        id: String
    ) async throws -> AdminEditMediaAssetModel
    func update(
        id: String,
        input: AssetEditForm
    ) async throws
        -> AdminEditMediaAssetModel
}
