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

extension Asset.File.List.Interactor {
    protocol Interface: Sendable {

        func listMediaAssets(
            page: Int,
            search: String?,
            parentId: String?,
            view: Asset.File.List.Model.ViewMode,
            picker: Asset.File.List.Model.PickerState
        ) async throws -> Asset.File.List.Model

    }
}
