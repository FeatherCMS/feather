import FeatherAdmin
import HTML
import Hummingbird

struct AdminListUserIdentityDefaultController: AdminListUserIdentityController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListUserIdentityInteractor,
            presenter: any AdminListUserIdentityPresenter
        )

    func getUserIdentities(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissionSet = context.currentUserPermissions
        let permissions = AdminUser.Scope.identities
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: permissions
        )
        let page = request.queryPage()
        let pageSize = 20
        let search = request.querySearch()

        do {
            let result =
                canAccess
                ? try await interactor.execute(
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

            let state = UserIdentityTable.State(
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                canAccess: canAccess,
                permissions: permissionSet,
                canAdd: permissionSet.contains(permissions.create),
                identities: result.items,
                page: result.page,
                pageSize: result.size,
                total: result.total,
                search: search ?? "",
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your identity cannot access user identities.",
                breadcrumb: .init(
                    links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "User", link: "/admin/user/"),
                        .init(
                            label: "Identities",
                            link: "/admin/user/identities/"
                        ),
                    ]
                )
            )
            return presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error)
        }
    }

    func getUserIdentitiesBulkRemoveConfirmation(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (_, presenter) = buildRuntime(request, context)
        let selectedIds = request.queryStrings("selectedIds")
        let page = request.queryPage()
        let search = request.querySearch()
        guard !selectedIds.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: ListBulkRemoveRedirect.location(
                        path: "/admin/user/identities/",
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
                selectedIds: selectedIds,
                page: page,
                search: search,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func postUserIdentitiesBulkRemove(
        request: Request,
        context: AppRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime(request, context)
        let payload = try await request.decode(
            as: ListBulkRemoveFormInput.self,
            context: context
        )
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.bulkRemove(ids: payload.normalizedSelectedIds)
        }
        return Response(
            status: .seeOther,
            headers: [
                .location: ListBulkRemoveRedirect.location(
                    path: "/admin/user/identities/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "User identity removed successfully." : nil
                )
            ]
        )
    }
}
