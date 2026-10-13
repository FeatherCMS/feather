import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebOverviewDefaultController: AdminViewWebOverviewController {
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewWebOverviewInteractor,
            any AdminViewWebOverviewPresenter
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
