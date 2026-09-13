import FeatherAdmin
import Hummingbird
import UserContracts

struct AdminGetUserOverviewDefaultController: AdminGetUserOverviewController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetUserOverviewInteractor,
            presenter: any AdminGetUserOverviewPresenter
        )

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return try await presenter.renderPage(
            model: try await interactor.getOverview()
        )
    }
}
