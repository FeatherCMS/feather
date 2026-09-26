import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddMediaAssetInteractor: Sendable {

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel

    func postAddMediaAsset(
        payload: AssetAddUpload
    ) async throws -> AdminAddMediaAssetModel
}
