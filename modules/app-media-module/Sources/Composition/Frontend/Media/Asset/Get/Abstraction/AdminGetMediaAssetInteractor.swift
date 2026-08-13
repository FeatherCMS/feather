import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminGetMediaAssetInteractor: Sendable {

    func getMediaAsset(
        id: String
    ) async throws -> AdminGetMediaAssetModel
}
