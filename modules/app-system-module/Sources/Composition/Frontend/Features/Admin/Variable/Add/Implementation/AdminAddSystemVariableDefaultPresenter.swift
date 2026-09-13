import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminAddSystemVariableDefaultPresenter:
    AdminAddSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(
        state: SystemVariableAddForm.State
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
            )
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

        var state = input.map {
            SystemVariableAddForm.State.from(input: $0)
        } ?? .empty()
        state.apply(errors: errors)

        return try await renderAddPage(state: state)
    }

    func renderSuccess() async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(
                    title: "Added",
                    message: "System variable added successfully."
                )
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
        case .conflict, .unavailable:
            var state = input.map {
                SystemVariableAddForm.State.from(input: $0)
            } ?? .empty()

            state.apply(
                error: formErrorMessage(for: error)
            )

            return try await renderAddPage(state: state)
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
            )
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
            )
        )
    }

    func renderInvalidNoncePage() async throws -> HTMLResponse {
        try await renderPage(
            content: NewAdminStatusView(
                state: .init(
                    title: "Form expired",
                    message: "This form is no longer valid. Please reload the page and try again."
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
    }

    private func renderPage<T: Component>(content: T) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage system variables",
            content: content
        )
    }

    private func formErrorMessage(
        for error: AdminAddSystemVariableError
    ) -> String {
        switch error {
        case .conflict:
            "A system variable with this key already exists."
        case .unavailable:
            "The system variable could not be created. Please try again."
        case .unauthorized, .forbidden:
            "The system variable could not be created."
        }
    }

}
