import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

extension MenuItem.List.Controller {
    struct Default: Interface {
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any MenuItem.List.Interactor.Interface,
                any MenuItem.List.Presenter.Interface
            >

        func getMenuItems(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            let menuId = try context.requiredID()
            let page = request.queryPage()
            let search = request.querySearch()
            let permissions = context.currentUserPermissions
            let canAccess = context.isCurrentUserAllowed(
                to: WebModule.Permissions.MenuItems.list
            )
            let emptyModel = MenuItem.List.Model(
                items: [],
                total: 0,
                page: page,
                pageSize: 20
            )
            let model: MenuItem.List.Model
            let error: String?
            if canAccess {
                do {
                    model = try await interactor.listMenuItems(
                        menuId: menuId,
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
                menuId: menuId,
                model: model,
                permissions: permissions,
                search: search,
                error: error
            )
        }

        func postMenuItemMove(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let interactor = buildRuntime(request, context).interactor
            let menuId = try context.requiredID()
            let itemId = try context.requiredParameter("itemId")
            let payload = try await request.decode(
                as: MenuItemMoveFormInput.self,
                context: context
            )
            try await interactor.move(
                menuId: menuId,
                itemId: itemId,
                beforeItemId: payload.normalizedBeforeItemID
            )
            return Response(status: .noContent)
        }
    }
}
