import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebModule

struct AdminListMenuItemDefaultController:
    AdminListMenuItemController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminListMenuItemInteractor,
            any AdminListMenuItemPresenter
        >

    func getMenuItems(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let menuId = try context.requiredID()
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebModule.Permissions.MenuItems.list
        )
        let emptyModel = AdminListMenuItemModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListMenuItemModel
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
