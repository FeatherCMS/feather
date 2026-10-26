import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.Add {
    enum Interactor {}
}

extension Asset.File.Add.Interactor {
    protocol Interface: Sendable {

        func folderID(forPath path: String) async throws -> String?

        func getAddMediaAsset() async throws -> Asset.File.Add.Model

        func postAddMediaAsset(
            payload: Asset.File.Add.Upload.Payload,
            variants: [String]?
        ) async throws -> Asset.File.Add.Model
    }
}
