import Hummingbird

protocol AdminGetMediaAssetInteractor: Sendable {

    func getMediaAsset(
        id: String
    ) async throws -> AdminGetMediaAssetModel
}
