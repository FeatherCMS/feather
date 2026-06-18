import Hummingbird

protocol AdminListMediaAssetInteractor: Sendable {

    func listMediaAssets(
        page: Int,
        search: String?,
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        picker: AdminListMediaAssetModel.PickerState
    ) async throws -> AdminListMediaAssetModel

    func bulkRemove(
        ids: [String]
    ) async throws

    func deleteFolder(
        id: String
    ) async throws
}
