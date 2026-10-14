import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

struct AdminListWebPageDefaultController:
    AdminListWebPageController
{
    let apiBuilder: WebAPIBuilder
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminListWebPageInteractor,
            any AdminListWebPagePresenter
        >

    func getWebPages(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> HTMLResponse {
        let (interactor, presenter) = buildRuntime((request, context))
        let page = request.queryPage()
        let search = request.querySearch()
        let permissions = context.currentUserPermissions
        let canAccess = context.isCurrentUserAllowed(
            to: WebPermissions.Pages.list
        )
        let emptyModel = AdminListWebPageModel(
            items: [],
            total: 0,
            page: page,
            pageSize: 20
        )
        let model: AdminListWebPageModel
        let error: String?
        if canAccess {
            do {
                model = try await interactor.listWebPages(
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
            model: model,
            permissions: permissions,
            search: search,
            error: error
        )
    }
    func postWebPagesRemove(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, _) = buildRuntime((request, context))
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let payload = nonceRequest.input
        if !payload.normalizedSelectedIds.isEmpty {
            try await interactor.remove(ids: payload.normalizedSelectedIds)
        }
        let location = AdminLocation.url(
            path: "/admin/web/pages/",
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
                message: "Web page removed successfully."
            )
        )
    }

    func postWebPageStatus(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let id = try context.requiredID()
        let payload = try await request.decode(
            as: AdminStatusActionFormInput.self,
            context: context
        )
        let repository = AdminListWebPageFormOpenAPIRepository(
            api: apiBuilder.makeWebAdmin(context)
        )
        let metadata = try await repository.load(id: id)
        let targetStatus = resolvedStatus(
            from: payload,
            current: metadata
        )
        try await AdminWebMetadataStatusUpdater(
            api: apiBuilder.makeWebAdmin(context)
        )
        .update(
            referenceType: "web.page",
            referenceID: id,
            status: targetStatus
        )
        return AdminNotificationFlash.redirect(
            to: payload.normalizedReturnTo ?? "/admin/web/pages/",
            notification: statusNotification(for: targetStatus)
        )
    }

    private func resolvedStatus(
        from payload: AdminStatusActionFormInput,
        current metadata: AdminMetadataFormValue
    ) -> String {
        let allowedStatuses = Set(["draft", "published", "archived"])
        let selectedStatus = payload.normalizedStatus
        return allowedStatuses.contains(selectedStatus)
            ? selectedStatus
            : metadata.normalizedStatus
    }

    private func statusNotification(
        for status: String
    ) -> AdminNotification.State {
        switch status {
        case "published":
            return .init(
                title: "Published",
                message: "Web page published successfully."
            )
        case "archived":
            return .init(
                title: "Archived",
                message: "Web page archived successfully."
            )
        default:
            return .init(
                title: "Draft",
                message: "Web page moved to draft successfully."
            )
        }
    }
}
