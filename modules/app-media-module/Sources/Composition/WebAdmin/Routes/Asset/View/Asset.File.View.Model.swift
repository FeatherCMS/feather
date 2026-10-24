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

extension Asset.File.View {
    struct Model: Sendable {
        let item: Components.Schemas.MediaAssetDetailSchema
        let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
    }
}
