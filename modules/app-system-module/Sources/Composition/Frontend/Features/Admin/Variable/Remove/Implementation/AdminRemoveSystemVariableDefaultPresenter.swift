import FeatherAdmin
import Hummingbird
import WebComponents

struct AdminRemoveSystemVariableDefaultPresenter:
    AdminRemoveSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderErrorPage(
        error: AdminRemoveSystemVariableError,
        cancel: String
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State

        switch error {
        case .notFound:
            state = .init(
                title: "System variables not found",
                message: "One or more selected variables may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to remove system variables."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot remove system variables."
            )
        case .conflict:
            state = .init(
                title: "Unable to remove system variables",
                message: "The selected variables could not be removed."
            )
        case .unavailable:
            state = .init(
                title: "System variables unavailable",
                message: "The request could not be completed. Please try again."
            )
        }

        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: status(for: error))
    }

    func renderInvalidNoncePage(
        cancel: String
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: NewAdminStatusView(
                state: .init(
                    title: "Confirmation expired",
                    message: "This confirmation is no longer valid. Please try again."
                ),
                icon: FeatherIcons.alertCircle(),
                action: NewAdminButton("Back", href: cancel, style: .secondary)
            )
        )
        return HTMLResponse(content: page.content, status: .badRequest)
    }

    func renderSuccess(
        location: String,
        count: Int
    ) -> Response {
        AdminNotificationFlash.redirect(
            to: location,
            notification: .init(
                title: "Removed",
                message: count == 1
                    ? "System variable removed successfully."
                    : "\(count) system variables removed successfully."
            )
        )
    }

    private func status(
        for error: AdminRemoveSystemVariableError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .unavailable:
            .serviceUnavailable
        }
    }

    func renderRemoveConfirmation(
        page: Int,
        search: String?,
        ids: [String],
        names: [String],
        returnTo: String?
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        let cancel = NewAdminLocation.removeCancel(
            path: SystemVariableRoutes.list.description,
            returnTo: returnTo
        )
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: NewAdminConfirmation(
                breadcrumb: SystemVariableRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Remove selected variables",
                    description:
                        "You’re about to permanently remove the selected system variables. This action cannot be undone."
                ),
                selectedItems: names,
                action: SystemVariableRoutes.remove.description,
                cancel: cancel,
                hiddenFields: ids.map {
                    .init(name: "ids", value: $0)
                } + [
                    .init(name: "_nonce", value: nonceToken),
                    .init(name: "returnTo", value: cancel),
                ]
            )
        )
    }

}
