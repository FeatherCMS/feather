import Hummingbird

struct AdminListSystemJobDefaultController: AdminListSystemJobController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminListSystemJobInteractor, presenter: AdminListSystemJobDefaultPresenter)

    func getSystemJobs(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        do {
            return runtime.presenter.render(
                model: try await runtime.interactor.list(page: page, search: search),
                search: search ?? "",
                permissions: context.currentUserPermissions
            )
        }
        catch let error {
            return runtime.presenter.renderError(
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }
}
