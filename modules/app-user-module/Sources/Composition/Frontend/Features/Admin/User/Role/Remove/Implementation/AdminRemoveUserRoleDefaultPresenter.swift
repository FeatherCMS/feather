import FeatherAdmin
import Hummingbird

struct AdminRemoveUserRoleDefaultPresenter: AdminRemoveUserRolePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        guard items.count == 1 else {
            return try await renderBulkRemovePage(
                items: items,
                returnTo: returnTo
            )
        }
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user role",
            content: UserRoleConfirmation(
                id: items[0].id,
                name: items[0].label,
                nonceToken: nonceToken
            )
        )
    }

    private func renderBulkRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: UserRoleRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user roles",
            content: NewAdminRemoveConfirmation(
                breadcrumb: UserRoleRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected user roles",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: UserRoleRoutes.remove.description,
                cancel: cancel,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) } + [
                    .init(name: "_nonce", value: nonceToken),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

    func renderErrorPage(error: AdminRemoveUserRoleError, cancel: String)
        async throws -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "User role not found",
                message: "This user role may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to remove user roles."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot remove user roles."
            )
        case .conflict:
            state = .init(
                title: "Unable to remove user role",
                message: "The user role could not be removed."
            )
        case .unavailable:
            state = .init(
                title: "User role unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user role",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    func renderSuccess(location: String, count: Int) -> Response {
        AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: count == 1
                    ? "User role removed successfully."
                    : "(count) user roles removed successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to remove user roles.",
            status: .unauthorized
        )
    }
    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot remove user roles.",
            status: .forbidden
        )
    }
    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Confirmation expired",
            message: "This confirmation is no longer valid. Please try again.",
            status: .badRequest,
            cancel: cancel
        )
    }

    private func renderStatusPage(
        title: String,
        message: String,
        status: HTTPResponse.Status,
        cancel: String = UserRoleRoutes.list.description
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user role",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func status(for error: AdminRemoveUserRoleError)
        -> HTTPResponse.Status
    {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .unavailable: .serviceUnavailable
        }
    }
}
