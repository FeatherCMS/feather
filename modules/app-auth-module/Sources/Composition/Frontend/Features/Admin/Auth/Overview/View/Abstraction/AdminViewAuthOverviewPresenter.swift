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

protocol AdminViewAuthOverviewPresenter: Sendable {

    func renderOverview(
        model: AdminViewAuthOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse
}
