import Hummingbird

struct AdminListBlogAuthorLinkDefaultController:
    AdminListBlogAuthorLinkController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListBlogAuthorLinkInteractor,
            presenter: any AdminListBlogAuthorLinkPresenter
        )

    func getBlogAuthorLinks(
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
            scope: AdminBlog.Scope.authorLinks
        )
        let emptyModel = AdminListBlogAuthorLinkModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListBlogAuthorLinkModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listBlogAuthorLinks(
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

    func getBlogAuthorLinksBulkRemoveConfirmation(
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
                    .location: "/admin/blog/authors/\(menuId)/"
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

    func postBlogAuthorLinksBulkRemove(
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
                .location:
                    !payload.normalizedSelectedIds.isEmpty
                    ? AdminToastRedirect.location(
                        defaultPath: "/admin/blog/authors/\(menuId)/",
                        title: "Removed",
                        message: "Link removed successfully."
                    )
                    : "/admin/blog/authors/\(menuId)/"
            ]
        )
    }
}
