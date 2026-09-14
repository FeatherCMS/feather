import FeatherAdmin
import Hummingbird

struct AdminViewContactOverviewDefaultController:
    AdminViewContactOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewContactOverviewInteractor,
            presenter: any AdminViewContactOverviewPresenter
        )

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return try await presenter.renderOverview(
            model: try await interactor.getOverview(),
            permissions: context.currentUserPermissions
        )
    }
}
