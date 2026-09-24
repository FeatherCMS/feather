import FeatherAdmin
import Hummingbird

struct AdminViewNewsletterOverviewDefaultController:
    AdminViewNewsletterOverviewController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminViewNewsletterOverviewInteractor,
            any AdminViewNewsletterOverviewPresenter
        >

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        return try await presenter.renderOverview(
            model: try await interactor.getOverview(),
            permissions: context.currentUserPermissions
        )
    }
}
