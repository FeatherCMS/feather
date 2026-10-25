import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import SystemModule
import WebComponents

extension Permission.Remove.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Permission.Router.Routes

        func renderRemovePage(
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
                        title: "Remove selected permissions",
                        description:
                            "You’re about to permanently remove the selected system permissions. This action cannot be undone."
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

        func renderErrorPage(
            error: Permission.Remove.Error,
            cancel: String
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
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
                    message:
                        "Please sign in again to remove system permissions."
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
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage system permissions",
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

        func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse
        {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage system permissions",
                content: AdminStatusView(
                    state: .init(
                        title: "Confirmation expired",
                        message:
                            "This confirmation is no longer valid. Please try again."
                    ),
                    icon: FeatherIcons.alertCircle(),
                    action: AdminButton("Back", href: cancel, style: .secondary)
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
            for error: Permission.Remove.Error
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
}
