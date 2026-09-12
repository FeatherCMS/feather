import FeatherAdmin
import Hummingbird

struct AdminGetSystemOverviewDefaultController: AdminGetSystemOverviewController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetSystemOverviewInteractor,
            presenter: any AdminGetSystemOverviewPresenter
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
