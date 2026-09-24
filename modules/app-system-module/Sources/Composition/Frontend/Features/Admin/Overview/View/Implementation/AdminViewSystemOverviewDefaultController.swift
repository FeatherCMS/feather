import FeatherAdmin
import Hummingbird

struct AdminViewSystemOverviewDefaultController:
    AdminViewSystemOverviewController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewSystemOverviewInteractor,
            any AdminViewSystemOverviewPresenter
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
