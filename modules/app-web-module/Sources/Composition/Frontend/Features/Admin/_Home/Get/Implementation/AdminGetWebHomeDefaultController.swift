import FeatherAdmin
import Hummingbird
import OpenAPIRuntime

struct AdminGetWebHomeDefaultController: AdminGetWebHomeController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminGetWebHomeInteractor,
            presenter: any AdminGetWebHomePresenter
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
