import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminRemoveMediaAssetInteractor: Sendable {

    func postRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel
}
