import FeatherAdmin
import FeatherValidation
import Hummingbird
import WebComponents

struct AdminEditRedirectRuleDefaultPresenter: AdminEditRedirectRulePresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: RedirectRuleEditForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: RedirectRuleEditPage(
                id: id,
                form: state,
                nonceToken: nonceToken,
                permissions: permissions
            ),
            status: .ok
        )
    }

    func renderValidationError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state =
            input.map(RedirectRuleEditForm.State.from(input:)) ?? .empty()
        state.apply(
            errors: Dictionary(
                uniqueKeysWithValues: error.failures.map {
                    ($0.key, $0.message)
                }
            )
        )
        return try await renderEditPage(
            id: id,
            state: state,
            permissions: context.currentUserAdminListActions
        )
        .withStatus(.unprocessableContent)
    }

    func renderEditError(
        id: String,
        input: RedirectRuleEditFormInput?,
        error: AdminEditRedirectRuleError
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound:
            return try await renderStatusPage(
                title: "Redirect rule not found",
                message: "This redirect rule may have been removed.",
                status: .notFound
            )
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to edit redirect rules.",
                status: .unauthorized
            )
        case .forbidden: return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A redirect rule with this source already exists.",
                status: .conflict,
                id: id
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The redirect rule could not be updated. Please try again.",
                status: .serviceUnavailable,
                id: id
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: RedirectRuleRoutes.list.description,
            notification: .init(
                title: "Saved",
                message: "Redirect rule updated successfully."
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot edit redirect rules.",
            status: .forbidden
        )
    }
    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Form expired",
            message:
                "This form is no longer valid. Please reload the page and try again.",
            status: .badRequest
        )
    }

    private func renderFormError(
        input: RedirectRuleEditFormInput?,
        message: String,
        status: HTTPResponse.Status,
        id: String
    ) async throws -> HTMLResponse {
        var state =
            input.map(RedirectRuleEditForm.State.from(input:)) ?? .empty()
        state.error = message
        return try await renderEditPage(
            id: id,
            state: state,
            permissions: context.currentUserAdminListActions
        )
        .withStatus(status)
    }

    private func renderStatusPage(
        title: String,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            ),
            status: status
        )
    }

    private func renderPage<T: Component>(
        content: T,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage redirect rules",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }
}

extension HTMLResponse {
    fileprivate func withStatus(_ status: HTTPResponse.Status) -> HTMLResponse {
        HTMLResponse(content: content, status: status)
    }
}
