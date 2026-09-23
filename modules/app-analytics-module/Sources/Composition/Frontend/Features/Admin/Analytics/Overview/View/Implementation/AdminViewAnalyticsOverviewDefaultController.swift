import FeatherAdmin
import Hummingbird

struct AdminViewAnalyticsOverviewDefaultController:
    AdminViewAnalyticsOverviewController
{

    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewAnalyticsOverviewInteractor,
            any AdminViewAnalyticsOverviewPresenter
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
