import Hummingbird

struct AdminGetUserHomeDefaultController: AdminGetUserHomeController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetUserHomeInteractor,
            presenter: any AdminGetUserHomePresenter
        )

    func getHome(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        return presenter.renderPage(
            model: try await interactor.getHome(),
            permissions: context.currentUserPermissions
        )
    }
}
