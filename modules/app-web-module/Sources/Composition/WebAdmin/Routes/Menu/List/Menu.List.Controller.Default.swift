import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension WebModule.Menu.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any WebModule.Menu.List.Interactor.Interface,
                any WebModule.Menu.List.Presenter.Interface
            >

        func getMenus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: Menu.Permissions.list
            )
            let emptyModel = WebModule.Menu.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )
            let model: WebModule.Menu.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.listMenus(
                        page: page,
                        search: search
                    )
                    error = nil
                }
                catch let caughtError {
                    model = emptyModel
                    error = caughtError.displayMessage
                }
            }
            else {
                model = emptyModel
                error = nil
            }
            return try await presenter.renderListPage(
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }
    }
}
