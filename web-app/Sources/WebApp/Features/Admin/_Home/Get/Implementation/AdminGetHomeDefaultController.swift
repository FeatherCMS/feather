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
        let model = try await interactor.getHome(
            permissions: context.currentUserPermissions
        )
        return presenter.renderPage(model: model)
    }
}
