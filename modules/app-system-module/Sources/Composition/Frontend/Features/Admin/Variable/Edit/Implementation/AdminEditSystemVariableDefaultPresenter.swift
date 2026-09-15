import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import SystemContracts
import WebComponents

struct AdminEditSystemVariableDefaultPresenter:
    AdminEditSystemVariablePresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>
    ) async throws -> HTMLResponse {
        try await renderEditPage(
            id: id,
            state: state,
            permissions: permissions,
            status: .ok
        )
    }

    private func renderEditPage(
        id: String,
        state: SystemVariableEditForm.State,
        permissions: Set<PermissionKey>,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(permissions)
        let nonceToken = await AdminNonceStore.shared.issue(
            sessionToken: context.sessionToken
        )
        return try await renderPage(
            content: SystemVariableEditPage(
                form: SystemVariableEditForm(
                    state: state,
                    action: SystemVariableRoutes.edit(RouterPath(id))
                        .description,
                    viewHref: SystemVariableRoutes.details(RouterPath(id))
                        .description,
                    removeHref: actions.allows(
                        SystemPermissions.Variables.delete
                    )
                        ? NewAdminLocation.remove(
                            path: SystemVariableRoutes.remove.description,
                            ids: [id],
                            returnTo: SystemVariableRoutes.edit(RouterPath(id))
                                .description
                        ) : nil,
                    nonceToken: nonceToken
                )
            ),
            status: status
        )
    }

    func renderValidationError(
        id: String,
        input: SystemVariableEditFormInput?,
        permissions: Set<PermissionKey>,
        error: ValidationError
    ) async throws -> HTMLResponse {
        var errors: [String: String] = [:]
        for failure in error.failures {
            errors[failure.key] = failure.message
        }

        var state =
            input.map {
                SystemVariableEditForm.State.from(input: $0)
            } ?? .empty()
        state.apply(errors: errors)

        return try await renderEditPage(
            id: id,
            state: state,
            permissions: permissions,
            status: .unprocessableContent
        )
    }

    func renderEditError(
        id: String,
        input: SystemVariableEditFormInput?,
        permissions: Set<PermissionKey>,
        error: AdminEditSystemVariableError
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound, .unauthorized, .forbidden:
            return try await renderErrorPage(error: error)
        case .conflict:
            return try await renderFormError(
                id: id,
                input: input,
                permissions: permissions,
                message: "A system variable with this key already exists.",
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                id: id,
                input: input,
                permissions: permissions,
                message:
                    "The system variable could not be saved. Please try again.",
                status: .serviceUnavailable
            )
        }
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

    func renderSuccess(id: String) -> Response {
        AdminNotificationFlash.redirect(
            to: SystemVariableRoutes.edit(RouterPath(id)).description,
            notification: .init(
                title: "Saved",
                message: "System variable edited successfully."
            )
        )
    }

    func renderErrorPage(
        error: AdminEditSystemVariableError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State

        switch error {
        case .notFound:
            state = .init(
                title: "System variable not found",
                message: "This system variable may have been removed."
            )
        case .unauthorized:
            state = .init(
                title: "Session expired",
                message: "Please sign in again."
            )
        case .forbidden:
            state = .init(
                title: "Forbidden",
                message: "Your account cannot edit system variables."
            )
        case .conflict:
            state = .init(
                title: "Unable to save changes",
                message: "A system variable with this key already exists."
            )
        case .unavailable:
            state = .init(
                title: "System variable unavailable",
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
            title: "Manage system variables",
            content: content
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        id: String,
        input: SystemVariableEditFormInput?,
        permissions: Set<PermissionKey>,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        var state =
            input.map {
                SystemVariableEditForm.State.from(input: $0)
            } ?? .empty()
        state.apply(error: message)

        return try await renderEditPage(
            id: id,
            state: state,
            permissions: permissions,
            status: status
        )
    }

    private func status(
        for error: AdminEditSystemVariableError
    ) -> HTTPResponse.Status {
        switch error {
        case .notFound:
            .notFound
        case .unauthorized:
            .unauthorized
        case .forbidden:
            .forbidden
        case .conflict:
            .conflict
        case .unavailable:
            .serviceUnavailable
        }
    }

}
