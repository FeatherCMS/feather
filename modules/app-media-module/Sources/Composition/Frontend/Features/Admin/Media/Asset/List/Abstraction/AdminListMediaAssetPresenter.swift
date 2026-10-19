import FeatherAdmin
import FeatherModuleKit
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
        permissions: AdminListActions,
    ) async throws -> HTMLResponse

    func renderErrorPage(
        message: String,
        picker: Bool
    ) async throws -> HTMLResponse

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse
}
