import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebMenuItemDefaultController:
    AdminListWebMenuItemController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListWebMenuItemInteractor,
            presenter: any AdminListWebMenuItemPresenter
        )

    func getWebMenuItems(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
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

    func getWebMenuItemsRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let selectedIds = request.queryStrings("ids")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: NewAdminLocation.url(
                        path: "/admin/web/menus/\(menuId)/",
                        page: page,
                        search: search
                    )
                ]
            )
        }
        return
            try await presenter.renderRemoveConfirmation(
                menuId: menuId,
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postWebMenuItemsRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(
                menuId: menuId,
                ids: payload.normalizedSelectedIds
            )
        }
        let location = NewAdminLocation.url(
            path: "/admin/web/menus/\(menuId)/",
            page: payload.normalizedPage,
            search: payload.normalizedSearch
        )
        guard !payload.normalizedSelectedIds.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        return AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: "Item removed successfully."
            )
        )
    }

    func postWebMenuItemMove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
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
