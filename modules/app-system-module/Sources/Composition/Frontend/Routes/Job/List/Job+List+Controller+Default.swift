import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Job.List.Controller {
    struct Default: WebAdmin.System.Job.List.Controller.Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Job.List.Interactor.Interface,
                any WebAdmin.System.Job.List.Presenter.Interface
            >

        func getSystemJobs(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime((request, context))
            let page = request.queryPage()
            let search = request.querySearch()
            let status = request.queryString("status").flatMap(Int.init)
            let permissions = context.currentUserAdminListActions
            guard
                context.isCurrentUserAllowed(
                    to: SystemModule.Job.Permissions.list
                )
            else {
                return try await runtime.presenter.renderErrorPage(
                    error: .forbidden
                )
            }
            do {
                return try await runtime.presenter.renderListPage(
                    model: try await runtime.interactor.list(
                        page: page,
                        search: search,
                        status: status
                    ),
                    permissions: permissions,
                    search: search,
                    status: status
                )
            }
            catch let error as WebAdmin.System.Job.List.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
            }
        }
    }
}
