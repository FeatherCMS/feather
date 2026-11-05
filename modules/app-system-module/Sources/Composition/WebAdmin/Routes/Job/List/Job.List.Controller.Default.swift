import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Job.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Job.List.Interactor.Interface,
                any Job.List.Presenter.Interface
            >

        func getSystemJobs(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
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
            catch let error as Job.List.Error {
                return try await runtime.presenter.renderErrorPage(error: error)
            }
        }
    }
}
