import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemPermissionDefaultPresenter:
    AdminAddSystemPermissionPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemPermissionAddForm.State
    ) async throws -> HTMLResponse {
        try await renderAddPage(state: state, status: .ok)
    }

    private func renderAddPage(
        state: SystemPermissionAddForm.State,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemPermissionAddPage(
                state: .init(form: state, nonceToken: nonceToken)
            ),
            status: status
        )
    }

    func renderValidationError(
        input: SystemPermissionAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var errors: [String: String] = [:]
        for failure in error.failures {
            errors[failure.key] = failure.message
        }
        var state = input.map(SystemPermissionAddForm.State.from) ?? .empty()
        state.apply(errors: errors)
        return try await renderAddPage(
            state: state,
            status: .unprocessableContent
        )
    }

    func renderAddError(
        input: SystemPermissionAddFormInput?,
        error: AdminAddSystemPermissionError
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized, .forbidden:
            return try await renderErrorPage(error: error)
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A system permission with this key already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The system permission could not be created. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: SystemPermissionRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "System permission added successfully."
            )
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderErrorPage(error: .forbidden)
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(
                    title: "Form expired",
                    message:
                        "This form is no longer valid. Please reload the page and try again."
                ),
                icon: FeatherIcons.alertCircle()
            ),
            status: .badRequest
        )
    }

    private func renderErrorPage(
        error: AdminAddSystemPermissionError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to create system permissions."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot create system permissions."
            )
        case .conflict:
            state = .init(
                title: "Unable to create permission",
                message: "A system permission with this key already exists."
            )
        case .unavailable:
            state = .init(
                title: "System permission unavailable",
                message: "The request could not be completed. Please try again."
            )
        }
        return try await renderPage(
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            ),
            status: status(for: error)
        )
    }

    private func renderPage<T: Component>(
        content: T,
        status: HTTPResponse.Status = .ok
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system permissions",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        input: SystemPermissionAddFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state = input.map(SystemPermissionAddForm.State.from) ?? .empty()
        state.error = message
        return try await renderAddPage(state: state, status: status)
    }

    private func status(
        for error: AdminAddSystemPermissionError
    ) -> HTTPResponse.Status {
        switch error {
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .unavailable: .serviceUnavailable
        }
    }
}
