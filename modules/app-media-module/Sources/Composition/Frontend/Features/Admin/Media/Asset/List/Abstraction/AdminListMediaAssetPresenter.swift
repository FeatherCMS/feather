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

protocol AdminListMediaAssetPresenter: Sendable {

    func renderListPage(
        model: AdminListMediaAssetModel,
        search: String?,
        permissions: NewAdminListActions,
    ) async throws -> HTMLResponse

    func renderErrorPage(
        message: String,
        picker: Bool
    ) async throws -> HTMLResponse

    func renderRemovePage(
        pageState: NewAdminListPageState,
        search: String?,
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse
}
