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

extension Asset.File.Edit.Repository {
    protocol Interface: Sendable {
        func getAsset(
            id: String
        ) async throws -> Components.Schemas.MediaAssetDetailSchema

        func updateAsset(
            id: String,
            title: String?,
            altText: String?
        ) async throws -> Components.Schemas.MediaAssetDetailSchema
    }
}

extension Asset.File.Edit {
    enum Repository {}
}
