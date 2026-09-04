import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

protocol AdminListMediaProcessorPresenter: Sendable {

    func renderListPage(
        items: [Components.Schemas.MediaProcessorListItemSchema],
        page: Int,
        pageSize: Int,
        total: Int,
        isAdded: Bool,
        isEdited: Bool,
        isRemoved: Bool,
        permissions: Set<String>,
        error: String?
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse
}
