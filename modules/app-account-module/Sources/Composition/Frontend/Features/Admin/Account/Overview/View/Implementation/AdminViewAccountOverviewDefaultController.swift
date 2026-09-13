import FeatherAdmin
import Hummingbird

struct AdminViewAccountOverviewDefaultController:
    AdminViewAccountOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewAccountOverviewInteractor,
            presenter: any AdminViewAccountOverviewPresenter
        )

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getOverview()
        return presenter.renderOverview(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
