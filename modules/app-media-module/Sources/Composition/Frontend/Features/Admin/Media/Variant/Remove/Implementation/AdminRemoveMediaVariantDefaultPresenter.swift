import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveMediaVariantDefaultPresenter: AdminRemoveMediaVariantPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(items: [NewAdminRemoveItemContext], returnTo: String?) async throws -> HTMLResponse {
        let nonce = await AdminNonceStore.shared.issue(sessionToken: context.sessionToken)
        let cancel = NewAdminLocation.removeCancel(path: MediaVariantRoutes.list.description, returnTo: returnTo)
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media variants",
            content: NewAdminRemoveConfirmation(
                breadcrumb: MediaVariantRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected variants",
                    description: "You’re about to permanently remove the selected media variants. This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: MediaVariantRoutes.remove.description,
                cancel: cancel,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) } + [
                    .init(name: "_nonce", value: nonce),
                    .init(name: "returnTo", value: cancel)
                ]
            )
        )
    }

    func renderErrorPage(error: AdminRemoveMediaVariantError, cancel: String) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound: state = .init(title: "Media variants not found", message: "One or more selected variants may have been removed.")
        case .unauthorized: state = .init(title: "Session expired", message: "Please sign in again to remove media variants.")
        case .forbidden: state = .init(title: "Forbidden", message: "Your account cannot remove media variants.")
        case .unavailable: state = .init(title: "Media variants unavailable", message: "The request could not be completed. Please try again.")
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove media variants",
            content: NewAdminStatusView(state: state, icon: FeatherIcons.alertCircle(), action: NewAdminButton("Back", href: cancel, style: .secondary))
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    func renderInvalidNoncePage(cancel: String) async throws -> HTMLResponse {
        try await renderErrorPage(error: .unavailable, cancel: cancel)
    }

    func renderSuccess(location: String, count: Int) -> Response {
        AdminNotificationFlash.redirect(to: location, notification: .init(title: "Removed", message: count == 1 ? "Media variant removed successfully." : "\(count) media variants removed successfully."))
    }

    private func status(for error: AdminRemoveMediaVariantError) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .unavailable: .serviceUnavailable
        }
    }
}
