import Hummingbird

protocol AdminAddMediaAssetInteractor: Sendable {

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel

    func postAddMediaAsset(
        payload: AssetAddForm
    ) async throws -> AdminAddMediaAssetModel
}
