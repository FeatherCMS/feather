import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminEditMediaAssetInteractor: Sendable {
    func load(
        id: String
    ) async throws -> AdminEditMediaAssetModel
    func update(
        id: String,
        input: AssetEditForm
    ) async throws
        -> AdminEditMediaAssetModel
}
