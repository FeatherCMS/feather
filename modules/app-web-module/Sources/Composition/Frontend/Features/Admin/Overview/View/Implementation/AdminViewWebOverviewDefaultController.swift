import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminViewWebOverviewDefaultController: AdminViewWebOverviewController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminViewWebOverviewInteractor,
            presenter: any AdminViewWebOverviewPresenter
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
