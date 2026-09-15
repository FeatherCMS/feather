import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListMediaProcessorPresenter: Sendable {

    func renderListPage(
        model: NewAdminListModel<
            Components.Schemas.MediaProcessorListItemSchema
        >,
        permissions: NewAdminListActions,
        search: String?
    ) async throws -> HTMLResponse

    func renderErrorPage(
        message: String
    ) async throws -> HTMLResponse

    func renderRemoveConfirmation(
        pageState: NewAdminListPageState,
        search: String?,
        selectedIds: [String],
        returnTo: String?
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse
}
