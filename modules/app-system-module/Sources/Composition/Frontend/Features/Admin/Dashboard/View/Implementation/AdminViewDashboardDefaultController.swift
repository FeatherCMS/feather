import FeatherAdmin
import Foundation
import Hummingbird

struct AdminViewDashboardDefaultController: AdminViewDashboardController {
    let buildRuntime:
        RuntimeBuilder<
            any AdminViewDashboardInteractor,
            any AdminViewDashboardPresenter
        >

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))

        let now = Date().timeIntervalSince1970
        let model = try await interactor.getHome(
            context: .init(
                // TODO: pass api instead of these. AdminDashboardEventContext should have DefaultRequestContext
                apiBaseURL: unsafe AppEnvironmentStore.current.apiBaseURL,
                sessionToken: context.sessionToken,
                permissions: context.currentUserPermissions,
                from: now - (7 * 24 * 60 * 60),
                to: now
            )
        )
        return try await presenter.renderPage(model: model)
    }
}
