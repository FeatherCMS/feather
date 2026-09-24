import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
        let preview: Components.Schemas.MediaAssetResolveVariantSchema?
    }

    enum EntryItem: Sendable {
        case asset(AssetItem)
        case folder(Components.Schemas.MediaFolderListItemSchema)
    }

    let entries: [EntryItem]
    let pageState: NewAdminListPageState
    let parentId: String?
    let currentFolder: Components.Schemas.MediaFolderDetailSchema?
    let ancestors: [Components.Schemas.MediaFolderDetailSchema]
    let view: ViewMode
    let picker: PickerState
}
