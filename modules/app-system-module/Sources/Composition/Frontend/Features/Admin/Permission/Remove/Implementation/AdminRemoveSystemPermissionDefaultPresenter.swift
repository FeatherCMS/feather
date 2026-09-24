import FeatherAdmin
import Hummingbird
import SystemContracts
import WebComponents

struct AdminRemoveSystemPermissionDefaultPresenter:
    AdminRemoveSystemPermissionPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: SystemPermissionRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: NewAdminRemoveConfirmation(
                breadcrumb: SystemPermissionRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected permissions",
                    description:
                        "You’re about to permanently remove the selected system permissions. This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: SystemPermissionRoutes.remove.description,
                cancel: cancel,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                    + [
                        .init(name: "_nonce", value: nonceToken),
                        .init(name: "returnTo", value: cancel),
                    ]
            )
        )
    }

    func renderErrorPage(
        error: AdminRemoveSystemPermissionError,
        cancel: String
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "System permissions not found",
                message:
                    "One or more selected permissions may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to remove system permissions."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot remove system permissions."
            )
        case .conflict:
            state = .init(
                title: "Unable to remove system permissions",
                message: "The selected permissions could not be removed."
            )
        case .unavailable:
            state = .init(
                title: "System permissions unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: NewAdminStatusView(
                state: .init(
                    title: "Confirmation expired",
                    message:
                        "This confirmation is no longer valid. Please try again."
                ),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: .badRequest)
    }

    func renderSuccess(location: String, count: Int) -> Response {
        AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: count == 1
                    ? "System permission removed successfully."
                    : "\(count) system permissions removed successfully."
            )
        )
    }

    private func status(
        for error: AdminRemoveSystemPermissionError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .unavailable: .serviceUnavailable
        }
    }
}
