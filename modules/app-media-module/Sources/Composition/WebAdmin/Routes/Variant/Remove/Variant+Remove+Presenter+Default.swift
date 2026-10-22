import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import MediaModule

extension Variant.Remove.Presenter {
    struct Default: Variant.Remove.Presenter.Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variant.Router.Routes

        func renderRemovePage(
            items: [AdminRemoveItemContext],
            returnTo: String?
        )
            async throws -> HTMLResponse
        {
            let nonce = await AdminNonceStore.shared.issue(
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
                        title: "Remove selected variants",
                        description:
                            "You’re about to permanently remove the selected media variants. This action cannot be undone."
                    ),
                    selectedItems: items.map(\.label),
                    action: routes.remove.path,
                    hiddenFields: items.map { .init(name: "ids", value: $0.id) }
                        + [
                            .init(name: "_nonce", value: nonce),
                            .init(name: "returnTo", value: cancel),
                        ]
                ),
                size: .small
            )
        }

        func renderErrorPage(error: Variant.Remove.Error, cancel: String)
            async throws -> HTMLResponse
        {
            let state: AdminStatusView.State
            switch error {
            case .notFound:
                state = .init(
                    title: "Media variants not found",
                    message:
                        "One or more selected variants may have been removed."
                )
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again to remove media variants."
                )
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot remove media variants."
                )
            case .unavailable:
                state = .init(
                    title: "Media variants unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Remove media variants",
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
            try await renderErrorPage(error: .unavailable, cancel: cancel)
        }

        func renderSuccess(location: String, count: Int) -> Response {
            AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: count == 1
                        ? "Media variant removed successfully."
                        : "\(count) media variants removed successfully."
                )
            )
        }

        private func status(for error: Variant.Remove.Error)
            -> HTTPResponse.Status
        {
            switch error {
            case .notFound: .notFound
            case .unauthorized: .unauthorized
            case .forbidden: .forbidden
            case .unavailable: .serviceUnavailable
            }
        }
    }
}
