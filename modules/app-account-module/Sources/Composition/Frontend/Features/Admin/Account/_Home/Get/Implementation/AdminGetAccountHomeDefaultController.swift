import FeatherAdmin
import Hummingbird

struct AdminGetAccountHomeDefaultController: AdminGetAccountHomeController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetAccountHomeInteractor,
            presenter: any AdminGetAccountHomePresenter
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
