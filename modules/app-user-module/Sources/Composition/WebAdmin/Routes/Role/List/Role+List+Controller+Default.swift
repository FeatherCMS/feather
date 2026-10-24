import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import UserModule

extension Role.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Role.List.Interactor.Interface,
                any Role.List.Presenter.Interface
            >

        func getUserRoles(
            request: Request,
            context: AuthenticatedRequestContext
        )
            async throws -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard
                context.isCurrentUserAllowed(
                    to: Role.Permissions.list
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            do {
                let model = try await interactor.list(
                    page: request.queryPage(),
                    size: Role.List.Router.pageSize,
                    search: request.querySearch()
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: context.currentUserAdminListActions.granted,
                    search: request.querySearch()
                )
            }
            catch let error as Role.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
