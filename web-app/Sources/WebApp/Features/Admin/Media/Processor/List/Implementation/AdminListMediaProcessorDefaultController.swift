import Hummingbird

struct AdminListMediaProcessorDefaultController:
    AdminListMediaProcessorController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListMediaProcessorInteractor,
            presenter: any AdminListMediaProcessorPresenter
        )

    func getListMediaProcessors(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminMedia.Scope.processors
        )
        let emptyModel = AdminListMediaProcessorModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListMediaProcessorModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listMediaProcessors(page: page)
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
            items: model.items,
            page: model.page,
            pageSize: model.pageSize,
            total: model.total,
            isAdded: request.hasQueryFlag("added"),
            isEdited: request.hasQueryFlag("edited"),
            isRemoved: request.hasQueryFlag("removed"),
            permissions: permissions,
            error: error
        )
    }

    func bulkRemoveConfirmation(
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
                        path: "/admin/media/processors/",
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
                page: page,
                search: search,
                selectedIds: selectedIds,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }

    func bulkRemove(
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
                    path: "/admin/media/processors/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Processor removed successfully." : nil
                )
            ]
        )
    }
}
