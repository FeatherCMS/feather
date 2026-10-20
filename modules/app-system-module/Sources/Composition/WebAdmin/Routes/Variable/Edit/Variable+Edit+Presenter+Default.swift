import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import Hummingbird
import SystemAdminAPI
import SystemModule
import WebComponents

extension Variable.Edit.Presenter {
    struct Default:
        Interface
    {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Variable.Router.Routes

        func renderEditPage(
            id: String,
            deleteID: String,
            state: SystemVariableEditForm.State,
            permissions: Set<PermissionKey>
        ) async throws -> HTMLResponse {
            try await renderEditPage(
                id: id,
                deleteID: deleteID,
                state: state,
                permissions: permissions,
                status: .ok
            )
        }

        private func renderEditPage(
            id: String,
            deleteID: String?,
            state: SystemVariableEditForm.State,
            permissions: Set<PermissionKey>,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let actions = AdminListActions(permissions)
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderPage(
                content: SystemVariableEditPage(
                    routes: routes,
                    form: SystemVariableEditForm(
                        state: state,
                        action: routes.editPath(id),
                        viewHref: routes.detailsPath(id),
                        removeHref: actions.allows(
                            SystemModule.Variable.Permissions.delete
                        )
                            ? deleteID.map { deleteID in
                                AdminLocation.remove(
                                    path: routes.remove.path,
                                    ids: [deleteID],
                                    returnTo: routes.editPath(id)
                                )
                            } : nil,
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
                deleteID: nil,
                state: state,
                permissions: permissions,
                status: .unprocessableContent
            )
        }

        func renderEditError(
            id: String,
            input: SystemVariableEditFormInput?,
            permissions: Set<PermissionKey>,
            error: Variable.Edit.Error
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
                content: AdminStatusView(
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
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "System variable edited successfully."
                )
            )
        }

        func renderErrorPage(
            error: Variable.Edit.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State

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
                    message:
                        "The request could not be completed. Please try again."
                )
            }

            return try await renderPage(
                content: AdminStatusView(
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
            let page = try await renderingEngine.renderAdminPage(
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
                deleteID: nil,
                state: state,
                permissions: permissions,
                status: status
            )
        }

        private func status(
            for error: Variable.Edit.Error
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
}
