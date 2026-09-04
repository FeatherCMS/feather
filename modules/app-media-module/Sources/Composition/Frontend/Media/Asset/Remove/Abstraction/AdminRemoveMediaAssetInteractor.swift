import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminRemoveMediaAssetInteractor: Sendable {

    func getRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel

    func postRemoveMediaAsset(
        id: String
    ) async throws -> AdminRemoveMediaAssetModel
}
