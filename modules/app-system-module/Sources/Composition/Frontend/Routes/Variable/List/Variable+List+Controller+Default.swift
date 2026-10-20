import FeatherAdmin
import FeatherModuleKit
import Hummingbird
import SystemAdminAPI
import SystemModule

extension WebAdmin.System.Variable.List.Controller {
    struct Default:
        WebAdmin.System.Variable.List.Controller.Interface
    {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any WebAdmin.System.Variable.List.Interactor.Interface,
                any WebAdmin.System.Variable.List.Presenter.Interface
            >

        func getSystemVariables(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: SystemModule.Variable.Permissions.list
            )
            guard canAccess else {
                return try await presenter.renderErrorPage(
                    error: .forbidden
                )
            }
            do {
                let model = try await interactor.listSystemVariables(
                    page: page,
                    search: search
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: Set(permissions.map(PermissionKey.init)),
                    search: search
                )
            }
            catch let error as WebAdmin.System.Variable.List.Error {
                return try await presenter.renderErrorPage(
                    error: error
                )
            }
        }

    }
}
