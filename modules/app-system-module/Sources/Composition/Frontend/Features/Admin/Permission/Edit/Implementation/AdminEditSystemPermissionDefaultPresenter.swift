import FeatherAdmin
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import WebComponents

struct AdminEditSystemPermissionDefaultPresenter:
    AdminEditSystemPermissionPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemPermissionEditForm.State,
        isEdited: Bool
    ) async throws -> HTMLResponse {
        try await renderEditPage(
            id: id,
            state: state,
            isEdited: isEdited,
            status: .ok
        )
    }

    private func renderEditPage(
        id: String,
        state: SystemPermissionEditForm.State,
        isEdited: Bool,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemPermissionEditPage(
                state: .init(
                    id: id,
                    isEdited: isEdited,
                    form: state,
                    nonceToken: nonceToken
                )
            ),
            status: status
        )
    }

    func renderValidationError(
        id: String,
        input: SystemPermissionEditFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var errors: [String: String] = [:]
        for failure in error.failures {
            errors[failure.key] = failure.message
        }
        var state = input.map(SystemPermissionEditForm.State.from) ?? .empty()
        state.apply(errors: errors)
        return try await renderEditPage(
            id: id,
            state: state,
            isEdited: false,
            status: .unprocessableContent
        )
    }

    func renderEditError(
        id: String,
        input: SystemPermissionEditFormInput?,
        error: AdminEditSystemPermissionError
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound, .unauthorized, .forbidden:
            return try await renderErrorPage(error: error)
        case .conflict:
            return try await renderFormError(
                id: id,
                input: input,
                message: "A system permission with this key already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                id: id,
                input: input,
                message: "The system permission could not be saved. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess(id: String) -> Response {
        AdminNotificationFlash.redirect(
            to: SystemPermissionRoutes.edit(RouterPath(id)).description,
            notification: .init(
                title: "Saved",
                message: "System permission edited successfully."
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
                    message: "This form is no longer valid. Please reload the page and try again."
                ),
                icon: FeatherIcons.alertCircle()
            ),
            status: .badRequest
        )
    }

    func renderErrorPage(
        error: AdminEditSystemPermissionError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        switch error {
        case .notFound:
            state = .init(
                title: "System permission not found",
                message: "This system permission may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again to edit system permissions."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot edit system permissions."
            )
        case .conflict:
            state = .init(
                title: "Unable to save changes",
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

    private func status(
        for error: AdminEditSystemPermissionError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound: .notFound
        case .unauthorized: .unauthorized
        case .forbidden: .forbidden
        case .conflict: .conflict
        case .unavailable: .serviceUnavailable
        }
    }

    private func renderFormError(
        id: String,
        input: SystemPermissionEditFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state = input.map(SystemPermissionEditForm.State.from) ?? .empty()
        state.error = message
        return try await renderEditPage(
            id: id,
            state: state,
            isEdited: false,
            status: status
        )
    }
}
