import FeatherAdmin
import Hummingbird
import SystemModule

extension WebAdmin.System.Permission.List.Controller {
    struct Default:
        WebAdmin.System.Permission.List.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Permission.List.Interactor.Interface,
                any WebAdmin.System.Permission.List.Presenter.Interface
            >

        func getSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let permissions = context.currentUserAdminListActions
            guard permissions.allows(SystemModule.Permission.Permissions.list)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            do {
                let model = try await interactor.listSystemPermissions(
                    page: request.queryPage(),
                    search: request.querySearch()
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: permissions,
                    search: request.querySearch()
                )
            }
            catch let error as WebAdmin.System.Permission.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
