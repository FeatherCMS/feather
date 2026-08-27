import FeatherAdmin
import Hummingbird

struct AdminGetAnalyticsHomeDefaultController: AdminGetAnalyticsHomeController {

    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAnalyticsHomeInteractor,
            presenter: any AdminGetAnalyticsHomePresenter
        )

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let model = try await interactor.getHome()
        return presenter.renderHome(
            model: model,
            permissions: context.currentUserPermissions
        )
    }
}
