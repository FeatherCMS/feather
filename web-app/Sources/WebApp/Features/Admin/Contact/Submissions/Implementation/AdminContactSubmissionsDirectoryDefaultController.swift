import Hummingbird

struct AdminContactSubmissionsDirectoryDefaultController: AdminContactSubmissionsDirectoryController {
    let buildRuntime: @Sendable (Request, AppRequestContext) -> (interactor: any AdminContactSubmissionsDirectoryInteractor, presenter: AdminContactSubmissionsDirectoryDefaultPresenter)

    func list(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        do {
            return presenter.render(items: try await interactor.list(), error: nil, permissions: context.currentUserPermissions)
        } catch {
            return presenter.render(items: [], error: error.displayMessage, permissions: context.currentUserPermissions)
        }
    }
}
