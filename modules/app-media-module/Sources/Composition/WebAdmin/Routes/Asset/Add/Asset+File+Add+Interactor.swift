import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add.Interactor {
    protocol Interface: Sendable {

        func folderID(forPath path: String) async throws -> String?

        func getAddMediaAsset() async throws -> Asset.File.Add.Model

        func postAddMediaAsset(
            payload: AssetAddUpload,
            variants: [String]?
        ) async throws -> Asset.File.Add.Model
    }
}
