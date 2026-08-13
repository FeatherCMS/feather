import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

protocol AdminListAuthMagicLinkPresenter: Sendable {

    func renderPage(
        state: AuthMagicLinkTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse

    func renderBulkRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
