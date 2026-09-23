import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemVariableDefaultPresenter:
    AdminAddSystemVariablePresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemVariableAddForm.State
    ) async throws -> HTMLResponse {
        try await renderAddPage(state: state, status: .ok)
    }

    private func renderAddPage(
        state: SystemVariableAddForm.State,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemVariableAddPage(
                form: SystemVariableAddForm(
                    state: state,
                    action: SystemVariableRoutes.add.description,
                    nonceToken: nonceToken
                )
            ),
            status: status
        )
    }

    func renderValidationError(
        input: SystemVariableAddFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var errors: [String: String] = [:]
        for failure in error.failures {
            errors[failure.key] = failure.message
        }

        var state =
            input.map {
                SystemVariableAddForm.State.from(input: $0)
            } ?? .empty()
        state.apply(errors: errors)

        return try await renderAddPage(
            state: state,
            status: .unprocessableContent
        )
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: SystemVariableRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "System variable added successfully."
            )
        )
    }

    func renderAddError(
        input: SystemVariableAddFormInput?,
        error: AdminAddSystemVariableError
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized:
            return try await renderUnauthorizedPage()
        case .forbidden:
            return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A system variable with this key already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The system variable could not be created. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(
                    title: "Session expired",
                    message: "Please sign in again to create system variables."
                ),
                icon: FeatherIcons.alertCircle()
            ),
            status: .unauthorized
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(
                    title: "Forbidden",
                    message: "Your account cannot create system variables."
                ),
                icon: FeatherIcons.alertCircle()
            ),
            status: .forbidden
        )
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

    private func renderPage<T: Component>(
        content: T,
        status: HTTPResponse.Status = .ok
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        input: SystemVariableAddFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state =
            input.map {
                SystemVariableAddForm.State.from(input: $0)
            } ?? .empty()
        state.apply(error: message)

        return try await renderAddPage(
            state: state,
            status: status
        )
    }

}
