import FeatherAdmin
import FeatherValidation
import Hummingbird
import UserContracts
import WebComponents

struct AdminAddUserIdentityDefaultPresenter: AdminAddUserIdentityPresenter {
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderAddPage(state: UserIdentityForm.State) async throws
        -> HTMLResponse
    {
        try await renderAddPage(state: state, status: .ok)
    }

    private func renderAddPage(
        state: UserIdentityForm.State,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: UserIdentityAddPage(form: state, nonceToken: nonceToken),
            status: status
        )
    }

    func renderValidationError(
        input: AdminAddUserIdentityFormInput?,
        error: ValidationError,
        roleOptions: [UserIdentityRoleOptionModel]
    ) async throws -> HTMLResponse {
        var state = UserIdentityForm.State.empty()
        if let input {
            state = .from(
                name: input.name,
                status: input.status,
                roleIds: input.roleIds ?? [],
                roleOptions: roleOptions
            )
        }
        else {
            state = .empty(roleOptions: roleOptions)
        }
        var errors: [String: String] = [:]
        for failure in error.failures { errors[failure.key] = failure.message }
        state.apply(errors: errors)
        return try await renderAddPage(
            state: state,
            status: .unprocessableContent
        )
    }

    func renderAddError(
        input: AdminAddUserIdentityFormInput?,
        error: AdminAddUserIdentityError,
        roleOptions: [UserIdentityRoleOptionModel]
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized: return try await renderUnauthorizedPage()
        case .forbidden: return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A user identity with this name already exists.",
                status: .conflict,
                roleOptions: roleOptions
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The user identity could not be created. Please try again.",
                status: .serviceUnavailable,
                roleOptions: roleOptions
            )
        }
    }

    func renderSuccess() -> Response {
        AdminNotificationFlash.redirect(
            to: UserIdentityRoutes.list.description,
            notification: .init(
                title: "Added",
                message: "User identity added successfully."
            )
        )
    }

    func renderUnauthorizedPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Session expired",
            message: "Please sign in again to create user identities.",
            status: .unauthorized
        )
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot create user identities.",
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
            title: "Manage user identities",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        input: AdminAddUserIdentityFormInput?,
        message: String,
        status: HTTPResponse.Status,
        roleOptions: [UserIdentityRoleOptionModel]
    ) async throws -> HTMLResponse {
        var state = UserIdentityForm.State.empty()
        if let input {
            state = .from(
                name: input.name,
                status: input.status,
                roleIds: input.roleIds ?? [],
                roleOptions: roleOptions
            )
        }
        else {
            state = .empty(roleOptions: roleOptions)
        }
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
