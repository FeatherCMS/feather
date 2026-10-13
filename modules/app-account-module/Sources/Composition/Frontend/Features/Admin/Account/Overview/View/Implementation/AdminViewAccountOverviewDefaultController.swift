import FeatherAdmin
import Hummingbird

struct AdminViewAccountOverviewDefaultController:
    AdminViewAccountOverviewController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAccountOverviewInteractor,
            any AdminViewAccountOverviewPresenter
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
