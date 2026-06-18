import AdminOpenAPI
import Foundation

struct AdminGetMediaAssetModel: Sendable {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
}
