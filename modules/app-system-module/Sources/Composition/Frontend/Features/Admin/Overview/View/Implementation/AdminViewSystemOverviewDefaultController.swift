import FeatherAdmin
import Hummingbird

struct AdminViewSystemOverviewDefaultController: AdminViewSystemOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewSystemOverviewInteractor,
            presenter: any AdminViewSystemOverviewPresenter
        )

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getOverview()
        return try await presenter.renderOverview(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
