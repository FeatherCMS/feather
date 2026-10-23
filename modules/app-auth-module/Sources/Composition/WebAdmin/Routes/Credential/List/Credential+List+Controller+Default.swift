import AuthAdminAPI
import AuthModule
import CSS
import FeatherValidation
import FeatherValidationFoundation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemWebAdmin
import UserAdminAPI
import UserWebAdmin
import WebBuilders
import WebComponents

extension Credential.List.Controller {
    struct Default: Interface {
        let routes: Credential.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any Credential.List.Interactor.Interface,
                any Credential.List.Presenter.Interface
            >

        func getCredentials(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let __runtimeBuild1 = buildRuntime(request, context)
            let interactor = __runtimeBuild1.interactor
            let presenter = __runtimeBuild1.presenter
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Credential.Permissions.list
            )
            let page = request.queryPage()
            let pageSize = 20
            let search = request.querySearch()

            do {
                let result: Credential.List.Result =
                    canAccess
                    ? try await interactor.execute(
                        page: page,
                        size: pageSize,
                        search: search
                    )
                    : .init(items: [], total: 0, page: page, size: pageSize)
                return try await presenter.renderPage(
                    state: .init(
                        canAccess: canAccess,
                        permissions: permissions,
                        credentials: result.items,
                        page: result.page,
                        pageSize: result.size,
                        total: result.total,
                        search: search ?? "",
                        breadcrumb: routes.listBreadcrumb
                    )
                )
            }
            catch let error as OpenAPIRepositoryError {
                return try await presenter.renderError(error: error)
            }
        }
    }
}
