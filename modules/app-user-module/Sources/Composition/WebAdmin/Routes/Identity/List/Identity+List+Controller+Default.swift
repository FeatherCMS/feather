import FeatherModuleKit
import FeatherWebShared
import FeatherWebAdmin
import Hummingbird
import UserModule

extension Identity.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Identity.List.Interactor.Interface,
                any Identity.List.Presenter.Interface
            >

        func getUserIdentities(
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
                    to: Identity.Permissions.list
                )
            else {
                return try await presenter.renderErrorPage(error: .forbidden)
            }
            let search = request.querySearch()
            let role = request.uri.queryParameters["role"].map(String.init)
            do {
                let model = try await interactor.list(
                    page: request.queryPage(),
                    size: Identity.List.Router.pageSize,
                    search: search,
                    role: role
                )
                return try await presenter.renderListPage(
                    model: model,
                    permissions: context.currentUserAdminListActions.granted,
                    search: search,
                    role: role
                )
            }
            catch let error as Identity.List.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }
    }
}
