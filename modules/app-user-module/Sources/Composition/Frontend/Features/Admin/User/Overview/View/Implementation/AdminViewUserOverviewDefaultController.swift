import FeatherAdmin
import Hummingbird
import UserContracts

struct AdminViewUserOverviewDefaultController: AdminViewUserOverviewController {
    let buildRuntime: RuntimeBuilder<
        any AdminViewUserOverviewInteractor,
        any AdminViewUserOverviewPresenter
    >

    func getOverview(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        return try await presenter.renderPage(
            model: try await interactor.getOverview()
        )
    }
}
