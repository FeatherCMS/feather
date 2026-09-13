import FeatherAdmin
import Hummingbird
import SystemContracts

struct AdminListSystemJobDefaultController: AdminListSystemJobController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListSystemJobInteractor,
            presenter: any AdminListSystemJobPresenter
        )

    func getSystemJobs(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserAdminListActions
        guard context.isCurrentUserAllowed(to: SystemPermissions.Jobs.list)
        else {
            return try await runtime.presenter.renderErrorPage(
                error: .forbidden
            )
        }
        do {
            return try await runtime.presenter.renderListPage(
                model: try await runtime.interactor.list(
                    page: page,
                    search: search
                ),
                permissions: permissions,
                search: search
            )
        }
        catch let error as AdminListSystemJobError {
            return try await runtime.presenter.renderErrorPage(error: error)
        }
    }
}
