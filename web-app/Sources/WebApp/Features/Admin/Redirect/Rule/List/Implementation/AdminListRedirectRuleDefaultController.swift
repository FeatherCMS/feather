import Hummingbird

struct AdminListRedirectRuleDefaultController:
    AdminListRedirectRuleController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminListRedirectRuleInteractor,
            presenter: any AdminListRedirectRulePresenter
        )

    func getRedirectRules(
        request: Request,
        context: AppRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime(request, context)
        let page = request.queryPage()
        let search = request.querySearch()
        let statusCode = request.queryString("statusCode")?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        let normalizedStatusCode =
            statusCode?.isEmpty == true
            ? nil
            : statusCode
        let parsedStatusCode = normalizedStatusCode.flatMap(Int.init)
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: .list,
            scope: AdminRedirect.Scope.rules
        )
        let emptyModel = AdminListRedirectRuleModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20,
            statusCode: normalizedStatusCode ?? ""
        )
        let model: AdminListRedirectRuleModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listRedirectRules(
                    page: page,
                    search: search,
                    statusCode: parsedStatusCode
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
            model: model,
            isAdded: request.hasQueryFlag("added"),
            isEdited: request.hasQueryFlag("edited"),
            isRemoved: request.hasQueryFlag("removed"),
            permissions: permissions,
            search: search,
            statusCode: normalizedStatusCode,
            error: error
        )
    }

    func getRedirectRulesBulkRemoveConfirmation(
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
                        path: "/admin/redirect/rules/",
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

    func postRedirectRulesBulkRemove(
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
                    path: "/admin/redirect/rules/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: !payload.normalizedSelectedIds.isEmpty
                        ? "Removed" : nil,
                    message: !payload.normalizedSelectedIds.isEmpty
                        ? "Redirect rule removed successfully." : nil
                )
            ]
        )
    }
}
