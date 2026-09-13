import FeatherAdmin
import Hummingbird

struct AdminGetAccountOverviewDefaultController:
    AdminGetAccountOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAccountOverviewInteractor,
            presenter: any AdminGetAccountOverviewPresenter
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
