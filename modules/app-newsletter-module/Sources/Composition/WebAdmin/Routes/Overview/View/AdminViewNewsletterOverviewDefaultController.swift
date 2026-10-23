import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminViewNewsletterOverviewDefaultController:
    AdminViewNewsletterOverviewController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminViewNewsletterOverviewInteractor,
            any AdminViewNewsletterOverviewPresenter
        >

    func getOverview(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        return try await presenter.renderOverview(
            model: try await interactor.getOverview(),
            permissions: context.currentUserPermissions
        )
    }
}
