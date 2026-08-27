import FeatherAdmin
import Hummingbird
import UserContracts

struct AdminGetUserHomeDefaultController: AdminGetUserHomeController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetUserHomeInteractor,
            presenter: any AdminGetUserHomePresenter
        )

    func getHome(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getHome(),
            permissions: context.currentUserPermissions
        )
    }
}
