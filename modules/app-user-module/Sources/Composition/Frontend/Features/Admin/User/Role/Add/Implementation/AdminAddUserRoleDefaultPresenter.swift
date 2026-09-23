import FeatherAdmin
import FeatherValidation
import Hummingbird
import UserContracts
import WebComponents

struct AdminAddUserRoleDefaultPresenter: AdminAddUserRolePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(state: UserRoleAddForm.State) async throws
        -> HTMLResponse
    {
        try await renderAddPage(state: state, status: .ok)
    }

    private func renderAddPage(
        state: UserRoleAddForm.State,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: UserRoleAddPage(form: state, nonceToken: nonceToken),
            status: status
        )
    }

    func renderValidationError(
        input: AdminAddUserRoleFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state = input.map(UserRoleAddForm.State.from(input:)) ?? .addEmpty()
        var errors: [String: String] = [:]
        for failure in error.failures { errors[failure.key] = failure.message }
        state.apply(errors: errors)
        return try await renderAddPage(
            state: state,
            status: .unprocessableContent
        )
    }

    func renderAddError(
        input: AdminAddUserRoleFormInput?,
        error: AdminAddUserRoleError
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized: return try await renderUnauthorizedPage()
        case .forbidden: return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                input: input,
                message:
                    "The generated role ID already exists. Please try again.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The user role could not be created. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: UserRoleRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "User role added successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to create user roles.",
            status: .unauthorized
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot create user roles.",
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

    private func renderPage<T: Component>(
        content: T,
        status: HTTPResponse.Status = .ok
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user roles",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        input: AdminAddUserRoleFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state = input.map(UserRoleAddForm.State.from(input:)) ?? .addEmpty()
        state.error = message
        return try await renderAddPage(state: state, status: status)
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
}
