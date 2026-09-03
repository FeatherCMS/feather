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

protocol AdminListAuthEmailPresenter: Sendable {

    func renderPage(
        state: AuthEmailTable.State
    ) -> HTMLResponse

    func renderError(
        error: OpenAPIRepositoryError
    ) -> HTMLResponse

    func renderRemoveConfirmation(
        selectedIds: [String],
        page: Int,
        search: String?,
        userID: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
