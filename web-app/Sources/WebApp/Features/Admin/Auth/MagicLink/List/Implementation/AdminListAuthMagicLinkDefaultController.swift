import HTML
import Hummingbird

struct AdminListAuthMagicLinkDefaultController: AdminListAuthMagicLinkController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListAuthMagicLinkInteractor,
            presenter: any AdminListAuthMagicLinkPresenter
        )

    func getAuthMagicLinks(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let permissionSet = context.currentUserPermissions
        let permissions = AdminAuth.Scope.magicLinks
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

            let state = AuthMagicLinkTable.State(
                isAdded: request.hasQueryFlag("added"),
                isEdited: request.hasQueryFlag("edited"),
                isRemoved: request.hasQueryFlag("removed"),
                canAccess: canAccess,
                permissions: permissionSet,
                canAdd: permissionSet.contains(permissions.create),
                links: result.items,
                page: result.page,
                pageSize: result.size,
                total: result.total,
                search: search ?? "",
                deniedInfo: "Forbidden",
                deniedMessage:
                    "Your account cannot access user magic links.",
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Auth", link: "/admin/auth/"),
                    .init(
                        label: "Magic links",
                        link: "/admin/auth/magic-links/"
                    ),
                ])
            )
            return presenter.renderPage(state: state)
        }
        catch let error as OpenAPIRepositoryError {
            return presenter.renderError(error: error)
        }
    }

    func getAuthMagicLinksBulkRemoveConfirmation(
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
                        path: "/admin/auth/magic-links/",
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

    func postAuthMagicLinksBulkRemove(
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
                    path: "/admin/auth/magic-links/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "User magic link removed successfully." : nil
                )
            ]
        )
    }
}
