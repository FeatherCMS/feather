import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetDashboardDefaultController: AdminGetDashboardController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetDashboardInteractor,
            presenter: any AdminGetDashboardPresenter
        )

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let now = Date().timeIntervalSince1970
        let model = try await interactor.getHome(
            context: .init(
                apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
                sessionToken: context.sessionToken,
                permissions: context.currentUserPermissions,
                from: now - (7 * 24 * 60 * 60),
                to: now
            )
        )
        return presenter.renderPage(model: model)
    }
}
