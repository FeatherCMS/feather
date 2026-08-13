import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetHomeDefaultController: AdminGetHomeController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetHomeInteractor,
            presenter: any AdminGetHomePresenter
        )

    func getHome(
        request: Request,
        context: AppRequestContext
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
