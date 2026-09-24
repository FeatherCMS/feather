import FeatherAdmin
import FeatherValidation
import Hummingbird
import UserContracts
import WebComponents

struct AdminEditUserRoleDefaultPresenter: AdminEditUserRolePresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(id: String, state: UserRoleEditForm.State) async throws
        -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: UserRoleEditPage(
                id: id,
                form: state,
                permissions: context.currentUserAdminListActions,
                nonceToken: nonceToken
            )
        )
    }

    func renderValidationError(
        id: String,
        input: AdminEditUserRoleFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state =
            input.map(UserRoleEditForm.State.from(input:))
            ?? .edit(name: "", notes: "")
        var errors: [String: String] = [:]
        for failure in error.failures { errors[failure.key] = failure.message }
        state.apply(errors: errors)
        return try await renderEditPage(id: id, state: state)
            .withStatus(.unprocessableContent)
    }

    func renderEditError(
        id: String,
        input: AdminEditUserRoleFormInput?,
        error: AdminEditUserRoleError
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to edit user roles.",
                status: .unauthorized
            )
        case .forbidden: return try await renderForbiddenPage()
        case .notFound:
            return try await renderStatusPage(
                title: "User role not found",
                message: "This user role may have been removed.",
                status: .notFound
            )
        case .conflict:
            return try await renderFormError(
                id: id,
                input: input,
                message: "A user role with this name already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                id: id,
                input: input,
                message:
                    "The user role could not be updated. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess(id: String) -> Response {
        AdminNotificationFlash.redirect(
            to: UserRoleRoutes.list.description,
            notification: .init(
                title: "Saved",
                message: "User role updated successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to edit user roles.",
            status: .unauthorized
        )
    }
    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot edit user roles.",
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
        id: String,
        input: AdminEditUserRoleFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state =
            input.map(UserRoleEditForm.State.from(input:))
            ?? .edit(name: "", notes: "")
        state.error = message
        return try await renderEditPage(id: id, state: state).withStatus(status)
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
}

extension HTMLResponse {
    fileprivate func withStatus(_ status: HTTPResponse.Status) -> HTMLResponse {
        HTMLResponse(content: content, status: status)
    }
}
