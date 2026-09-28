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
        let configuration: MediaAssetPopupConfiguration?
        let resetSelection: Bool

        var field: String? {
            guard let field = configuration?.field, !field.isEmpty else {
                return nil
            }
            return field
        }

        var allowedExtensions: AllowedExtensions {
            configuration?.allowedExtensions ?? .anything
        }

        var defaultFolderPath: String? {
            configuration?.defaultFolderPath
        }

        var previewVariant: String? {
            configuration?.previewVariant
        }

        var selectionMode: MediaAssetSelectionMode {
            configuration?.selectionMode ?? .single
        }
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
