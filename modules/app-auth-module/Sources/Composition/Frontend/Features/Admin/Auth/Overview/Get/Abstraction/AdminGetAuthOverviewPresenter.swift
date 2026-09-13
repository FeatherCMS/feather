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
import WebBuilders
import WebComponents

protocol AdminGetAuthOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminGetAuthOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
