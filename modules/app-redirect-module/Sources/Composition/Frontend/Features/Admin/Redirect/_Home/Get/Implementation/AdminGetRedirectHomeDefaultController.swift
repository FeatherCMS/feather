import FeatherAdmin
import Foundation
import Hummingbird

struct AdminGetRedirectHomeDefaultController: AdminGetRedirectHomeController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetRedirectHomeInteractor,
            presenter: any AdminGetRedirectHomePresenter
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
