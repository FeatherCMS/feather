import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebDomain
import WebModule

extension Menu.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            AuthenticatedRuntimeBuilder<
                any Menu.List.Interactor.Interface,
                any Menu.List.Presenter.Interface
            >

        func getWebMenus(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let (interactor, presenter) = buildRuntime((request, context))
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: WebModule.Permissions.Menus.list
            )
            let emptyModel = Menu.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )
            let model: Menu.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.listWebMenus(
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
