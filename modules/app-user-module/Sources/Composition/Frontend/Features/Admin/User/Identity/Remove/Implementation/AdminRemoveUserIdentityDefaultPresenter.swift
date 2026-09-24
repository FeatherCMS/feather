import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveUserIdentityDefaultPresenter: AdminRemoveUserIdentityPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
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
            title: "Remove user identity",
            content: UserIdentityConfirmation(
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
            path: UserIdentityRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user identities",
            content: NewAdminRemoveConfirmation(
                breadcrumb: UserIdentityRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected user identities",
                    description: "This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: UserIdentityRoutes.remove.description,
                cancel: cancel,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) } + [
                    .init(name: "_nonce", value: nonceToken),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

    func renderErrorPage(error: AdminRemoveUserIdentityError, cancel: String)
        async throws -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "User identity not found",
                message: "This user identity may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to remove user identities."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot remove user identities."
            )
        case .conflict:
            state = .init(
                title: "Unable to remove user identity",
                message: "The user identity could not be removed."
            )
        case .unavailable:
            state = .init(
                title: "User identity unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user identity",
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
                    ? "User identity removed successfully."
                    : "(count) user identities removed successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to remove user identities.",
            status: .unauthorized
        )
    }
    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot remove user identities.",
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
        cancel: String = UserIdentityRoutes.list.description
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove user identity",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func status(for error: AdminRemoveUserIdentityError)
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
