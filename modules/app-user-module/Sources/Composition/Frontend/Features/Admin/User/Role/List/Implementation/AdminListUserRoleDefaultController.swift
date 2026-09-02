import FeatherAdmin
import Hummingbird
import UserAdminAPI
import UserContracts

struct AdminListUserRoleDefaultController: AdminListUserRoleController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminListUserRoleInteractor,
            presenter: any AdminListUserRolePresenter
        )

    func getUserRoles(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let permissions = context.currentUserPermissions
        let permissionScope = UserPermissions.Roles.list
        do {
            let canAccess = context.isCurrentUserAllowed(
                to: permissionScope
            )
            let page = request.queryPage()
            let pageSize = 20
            let search = request.querySearch()
            let result:
                (
                    items: [Components.Schemas.UserRoleListItemSchema],
                    total: Int,
                    page: Int,
                    size: Int
                ) =
                    canAccess
                    ? try await runtime.interactor.execute(
                        page: page,
                        size: pageSize,
                        search: search
                    )
                    : (
                        items: [],
                        total: 0,
                        page: page,
                        size: pageSize
                    )
            return runtime.presenter.renderListPage(
                model: .init(
                    items: result.items,
                    total: result.total,
                    page: result.page,
                    pageSize: result.size
                ),
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                permissions: permissions,
                search: search,
                error: nil
            )
        }
        catch let error as OpenAPIRepositoryError {
            return runtime.presenter.renderListPage(
                model: .init(
                    items: [],
                    total: 0,
                    page: request.queryPage(),
                    pageSize: 20
                ),
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                permissions: permissions,
                search: request.querySearch(),
                error: runtime.presenter.errorState(error: error).message
            )
        }
    }

    func getUserRolesRemoveConfirmation(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListRemoveRedirect.location(
                        path: "/admin/user/roles/",
                        page: page,
                        search: search,
                        title: nil,
                        message: nil
                    )
                ]
            )
        }
        return try runtime.presenter
            .renderRemoveConfirmation(
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postUserRolesRemove(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let payload = try await request.decode(
            as: ListRemoveFormInput.self,
            context: context
        )
        let runtime = buildRuntime(request, context)
        if !payload.normalizedSelectedIds.isEmpty {
            try await runtime.interactor.remove(
                ids: payload.normalizedSelectedIds
            )
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListRemoveRedirect.location(
                    path: "/admin/user/roles/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "User role removed successfully." : nil
                )
            ]
        )
    }
}
