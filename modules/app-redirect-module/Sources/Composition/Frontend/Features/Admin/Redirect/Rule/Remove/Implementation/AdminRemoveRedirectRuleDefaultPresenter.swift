import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveRedirectRuleDefaultPresenter: AdminRemoveRedirectRulePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderRemovePage(items: [NewAdminRemoveItemContext], returnTo: String?)
        async throws -> HTMLResponse
    {
        guard items.count != 1 else {
            let item = items[0]
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderingEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Remove redirect rule",
                content: RedirectRuleConfirmation(
                    id: item.id,
                    source: item.label,
                    nonceToken: nonceToken,
                    returnTo: returnTo
                )
            )
        }
        return try await renderBulkRemovePage(items: items, returnTo: returnTo)
    }

    private func renderBulkRemovePage(
        items: [NewAdminRemoveItemContext],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove redirect rule",
            content: NewAdminRemoveConfirmation(
                breadcrumb: RedirectRuleRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected redirect rules",
                    description:
                        "You’re about to permanently remove the selected redirect rules. This action cannot be undone."
                ),
                selectedItems: items.map(\.label),
                action: RedirectRuleRoutes.remove.description,
                cancel: NewAdminLocation.removeCancel(
                    path: RedirectRuleRoutes.list.description,
                    returnTo: returnTo
                ),
                nonceToken: nonceToken,
                hiddenFields: items.map { .init(name: "ids", value: $0.id) }
            )
        )
    }

    func renderErrorPage(error: AdminRemoveRedirectRuleError, cancel: String)
        async throws -> HTMLResponse
    {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "Redirect rule not found",
                message: "This redirect rule may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to remove redirect rules."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot remove redirect rules."
            )
        case .conflict:
            state = .init(
                title: "Unable to remove redirect rule",
                message: "The redirect rule could not be removed."
            )
        case .unavailable:
            state = .init(
                title: "Redirect rule unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove redirect rule",
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
                    ? "Redirect rule removed successfully."
                    : "Redirect rules removed successfully."
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot remove redirect rules.",
            status: .forbidden,
            cancel: RedirectRuleRoutes.list.description
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
        cancel: String
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Remove redirect rule",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func status(for error: AdminRemoveRedirectRuleError)
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
