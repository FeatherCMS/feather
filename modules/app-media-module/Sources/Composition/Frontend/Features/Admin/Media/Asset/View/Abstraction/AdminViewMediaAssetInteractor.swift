import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminViewMediaAssetInteractor: Sendable {

    func getMediaAsset(
        id: String
    ) async throws -> AdminViewMediaAssetModel
}
