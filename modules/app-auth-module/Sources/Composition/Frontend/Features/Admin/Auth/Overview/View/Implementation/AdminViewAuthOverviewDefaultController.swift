import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherWebAdmin
import FeatherValidation
import FeatherValidationFoundation
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

struct AdminViewAuthOverviewDefaultController: AdminViewAuthOverviewController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAuthOverviewInteractor,
            any AdminViewAuthOverviewPresenter
        >

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let model = try await interactor.getOverview()
        return try await presenter.renderOverview(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
