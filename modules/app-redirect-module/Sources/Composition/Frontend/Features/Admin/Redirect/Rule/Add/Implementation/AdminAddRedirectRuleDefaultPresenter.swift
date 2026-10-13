import FeatherAdmin
import FeatherValidation
import Hummingbird
import WebComponents

struct AdminAddRedirectRuleDefaultPresenter: AdminAddRedirectRulePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: RedirectRuleAddForm.State,
        permissions: NewAdminListActions
    ) async throws -> HTMLResponse {
        try await renderPage(
            content: RedirectRuleAddPage(
                form: state,
                nonceToken: await AdminNonceStore.shared.issue(
                    sessionToken: context.sessionToken
                )
            ),
            status: .ok
        )
    }

    func renderValidationError(
        input: RedirectRuleAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state =
            input.map(RedirectRuleAddForm.State.from(input:)) ?? .empty()
        state.apply(
            errors: Dictionary(
                uniqueKeysWithValues: error.failures.map {
                    ($0.key, $0.message)
                }
            )
        )
        return try await renderAddPage(
            state: state,
            permissions: context.currentUserAdminListActions
        )
        .withStatus(.unprocessableContent)
    }

    func renderAddError(
        input: RedirectRuleAddFormInput?,
        error: AdminAddRedirectRuleError
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to add redirect rules.",
                status: .unauthorized
            )
        case .forbidden:
            return try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot add redirect rules.",
                status: .forbidden
            )
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A redirect rule with this source already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The redirect rule could not be added. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: RedirectRuleRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "Redirect rule added successfully."
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot add redirect rules.",
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
        input: RedirectRuleAddFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state =
            input.map(RedirectRuleAddForm.State.from(input:)) ?? .empty()
        state.error = message
        return try await renderAddPage(
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
