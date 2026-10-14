import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebAdminAPI
import WebContracts

struct AdminListWebMenuItemDefaultController:
    AdminListWebMenuItemController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListWebMenuItemInteractor,
            any AdminListWebMenuItemPresenter
        >

    func getWebMenuItems(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let menuId = try context.requiredID()
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebPermissions.MenuItems.list
        )
        let emptyModel = AdminListWebMenuItemModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebMenuItemModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listWebMenuItems(
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
    func postWebMenuItemMove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
        let menuId = try context.requiredID()
        let itemId = try context.requiredParameter("itemId")
        let payload = try await request.decode(
            as: WebMenuItemMoveFormInput.self,
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
