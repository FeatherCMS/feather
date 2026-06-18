import Hummingbird

protocol AdminRemoveMediaAssetInteractor: Sendable {

    func getRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel

    func postRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel
}
