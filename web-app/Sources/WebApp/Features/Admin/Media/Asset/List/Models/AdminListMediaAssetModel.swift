import AdminOpenAPI
import Foundation

struct AdminListMediaAssetModel: Sendable {
    enum ViewMode: String, Sendable {
        case grid
        case list
    }

    struct PickerState: Sendable {
        let isEnabled: Bool
        let field: String?
        let allowedExtensions: [String]
        let defaultFolderPath: String?
    }

    struct AssetItem: Sendable {
        let asset: Components.Schemas.MediaAssetListItemSchema
        let preview: Components.Schemas.MediaAssetVariantListItemSchema?
    }

    let folders: [Components.Schemas.MediaFolderListItemSchema]
    let items: [AssetItem]
    let total: Int
    let page: Int
    let pageSize: Int
    let parentId: String?
    let currentFolder: Components.Schemas.MediaFolderDetailSchema?
    let ancestors: [Components.Schemas.MediaFolderDetailSchema]
    let view: ViewMode
    let picker: PickerState
}
