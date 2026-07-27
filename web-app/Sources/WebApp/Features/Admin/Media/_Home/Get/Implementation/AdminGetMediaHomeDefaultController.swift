import Hummingbird

struct AdminGetMediaHomeDefaultController: AdminGetMediaHomeController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminGetMediaHomeInteractor,
            presenter: any AdminGetMediaHomePresenter
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
