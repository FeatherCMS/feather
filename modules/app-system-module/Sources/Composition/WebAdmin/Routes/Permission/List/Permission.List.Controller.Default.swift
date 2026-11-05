import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule

extension Permission.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Permission.List.Interactor.Interface,
                any Permission.List.Presenter.Interface
            >

        func getSystemPermissions(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let permissions = context.currentUserAdminListActions
            guard permissions.allows(SystemModule.Permission.Permissions.list)
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            do {
                let model = try await interactor.list(
                    page: request.queryPage(),
                    search: request.querySearch()
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: permissions,
                    search: request.querySearch()
                )
            }
            catch let error
                as Permission.List.Error
            {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
