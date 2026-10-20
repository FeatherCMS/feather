import FeatherWebAdmin
import Hummingbird
import UserModule

extension Role.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Role.Router.Routes

        func renderRemovePage(
            items: [AdminRemoveItemContext],
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
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: Role.Remove.Confirmation(
                    routes: routes,
                    id: items[0].id,
                    name: items[0].label,
                    nonceToken: nonceToken
                ),
                size: .small
            )
        }

        private func renderBulkRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            let cancel = AdminLocation.removeCancel(
                path: routes.list.path,
                returnTo: returnTo
            )
            return try await renderingEngine.renderAdminDialog(
                request: request,
                context: context,
                title: AdminRemoveConfirmation.dialogTitle,
                content: AdminRemoveConfirmation(
                    header: .primary(
                        title: "Remove selected user roles",
                        description: "This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.remove.path,
                    hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                        + [
                            .init(name: "_nonce", value: nonceToken),
                            .init(name: "returnTo", value: cancel),
                        ]
                ),
                size: .small
            )
        }

        func renderErrorPage(error: Role.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        {
            let state: AdminStatusView.State
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
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove user role",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
                )
            )
            return HTMLResponse(
                content: page.content,
                status: status(for: error)
            )
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
        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
        {
            try await renderStatusPage(
                title: "Confirmation expired",
                message:
                    "This confirmation is no longer valid. Please try again.",
                status: .badRequest,
                cancel: cancel
            )
        }

        private func renderStatusPage(
            title: String,
            message: String,
            status: HTTPResponse.Status,
            cancel: String? = nil
        ) async throws -> HTMLResponse {
            let cancel = cancel ?? routes.list.path
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove user role",
                content: AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func status(for error: Role.Remove.Error)
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
}
