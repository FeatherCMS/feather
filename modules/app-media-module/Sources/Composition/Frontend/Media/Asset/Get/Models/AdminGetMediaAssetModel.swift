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

struct AdminGetMediaAssetModel: Sendable {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
}
