import FeatherAdmin
import Hummingbird

struct AdminGetSystemJobDefaultController: AdminGetSystemJobController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            repository: any AdminGetSystemJobRepository,
            presenter: AdminGetSystemJobDefaultPresenter
        )

    func getSystemJob(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let runtime = buildRuntime(request, context)
        let id = try context.requiredID()
        do {
            return runtime.presenter.render(
                job: try await runtime.repository.get(id: id),
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
