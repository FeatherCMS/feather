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

    func folderID(forPath path: String) async throws -> String?

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel

    func postAddMediaAsset(
        payload: AssetAddUpload,
        variants: [String]?
    ) async throws -> AdminAddMediaAssetModel
}
