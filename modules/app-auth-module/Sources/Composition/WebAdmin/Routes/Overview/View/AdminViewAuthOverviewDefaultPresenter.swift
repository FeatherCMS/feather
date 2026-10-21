import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

struct AdminViewAuthOverviewDefaultPresenter: AdminViewAuthOverviewPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    let credentialRoutes: Credential.Router.Routes

    func renderOverview(
        model: AdminViewAuthOverviewModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: model.title,
            content: AdminViewAuthOverviewComponent(
                credentialRoutes: credentialRoutes
            )
        )
    }
}
