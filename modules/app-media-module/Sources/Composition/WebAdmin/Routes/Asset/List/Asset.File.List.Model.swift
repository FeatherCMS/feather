import FeatherModuleKit
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

extension Asset.File.List {
    struct Model: Sendable {
        enum ViewMode: String, Sendable {
            case grid
            case list
        }

        struct PickerState: Sendable {
            let isEnabled: Bool
            let configuration: Asset.Picker.Popup.Configuration?
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

            var selectionMode: Asset.Picker.SelectionMode {
                configuration?.selectionMode ?? .single
            }
        }

        struct AssetItem: Sendable {
            let asset: Components.Schemas.MediaAssetQueryItemFileSchema
            let preview: Components.Schemas.MediaAssetResolveVariantSchema?
        }

        enum EntryItem: Sendable {
            case asset(AssetItem)
            case folder(Components.Schemas.MediaFolderListItemSchema)
        }

        let entries: [EntryItem]
        let pageState: AdminListPageState
        let parentId: String?
        let currentFolder: Components.Schemas.MediaFolderDetailSchema?
        let ancestors: [Components.Schemas.MediaFolderDetailSchema]
        let view: ViewMode
        let picker: PickerState
    }
}
