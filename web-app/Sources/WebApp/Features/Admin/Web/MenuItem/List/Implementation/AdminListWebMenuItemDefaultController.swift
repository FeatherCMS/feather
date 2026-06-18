import Hummingbird

struct AdminListWebMenuItemDefaultController:
    AdminListWebMenuItemController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListWebMenuItemInteractor,
            presenter: any AdminListWebMenuItemPresenter
        )

    func getWebMenuItems(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminWeb.Scope.menuItems
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
        return presenter.renderListPage(
            menuId: menuId,
            model: model,
            isAdded: request.hasQueryFlag("added"),
            isEdited: request.hasQueryFlag("edited"),
            isRemoved: request.hasQueryFlag("removed"),
            permissions: permissions,
            search: search,
            error: error
        )
    }

    func getWebMenuItemsBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListBulkRemoveRedirect.location(
                        path: "/admin/web/menus/\(menuId)/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return
            try presenter.renderBulkRemoveConfirmation(
                menuId: menuId,
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postWebMenuItemsBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let menuId = try context.requiredID()
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(
                menuId: menuId,
                ids: payload.normalizedSelectedIds
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/web/menus/\(menuId)/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Item removed successfully." : nil
                )
            ]
        )
    }
}
