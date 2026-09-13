import FeatherAdmin
import FeatherValidation
import Hummingbird
import UserContracts
import WebComponents

struct AdminEditUserIdentityDefaultPresenter: AdminEditUserIdentityPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(id: String, state: UserIdentityForm.State) async throws
        -> HTMLResponse
    {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: UserIdentityEditPage(
                id: id,
                form: state,
                permissions: context.currentUserAdminListActions,
                nonceToken: nonceToken
            )
        )
    }

    func renderValidationError(
        id: String,
        input: AdminEditUserIdentityFormInput?,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var state =
            input.map {
                UserIdentityForm.State.from(
                    name: $0.normalizedName,
                    status: $0.normalizedStatus,
                    roleIds: $0.roleIds ?? []
                )
            } ?? .empty()
        var errors: [String: String] = [:]
        for failure in error.failures { errors[failure.key] = failure.message }
        state.apply(errors: errors)
        return try await renderEditPage(id: id, state: state)
            .withStatus(.unprocessableContent)
    }

    func renderEditError(
        id: String,
        input: AdminEditUserIdentityFormInput?,
        error: AdminEditUserIdentityError
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound:
            return try await renderStatusPage(
                title: "User identity not found",
                message: "This user identity may have been removed.",
                status: .notFound
            )
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to edit user identities.",
                status: .unauthorized
            )
        case .forbidden: return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                id: id,
                input: input,
                message: "A user identity with this name already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                id: id,
                input: input,
                message:
                    "The user identity could not be updated. Please try again.",
                status: .serviceUnavailable
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: UserIdentityRoutes.list.description,
            notification: .init(
                title: "Saved",
                message: "User identity updated successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to edit user identities.",
            status: .unauthorized
        )
    }
    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot edit user identities.",
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
        input: AdminEditUserIdentityFormInput?,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state =
            input.map {
                UserIdentityForm.State.from(
                    name: $0.normalizedName,
                    status: $0.normalizedStatus,
                    roleIds: $0.roleIds ?? []
                )
            } ?? .empty()
        state.error = message
        return try await renderEditPage(id: id, state: state).withStatus(status)
    }

    private func renderStatusPage(
        title: String,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user identities",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderPage<T: Component>(content: T) async throws
        -> HTMLResponse
    {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Manage user identities",
            content: content
        )
    }
}

extension HTMLResponse {
    fileprivate func withStatus(_ status: HTTPResponse.Status) -> HTMLResponse {
        HTMLResponse(content: content, status: status)
    }
}
