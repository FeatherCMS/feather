import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddMediaAssetInteractor: Sendable {

    func getAddMediaAsset() async throws -> AdminAddMediaAssetModel

    func postAddMediaAsset(
        payload: AssetAddForm
    ) async throws -> AdminAddMediaAssetModel
}
