import FeatherValidation
import FeatherWebShared
import FeatherWebAdmin
import Hummingbird
import UserModule
import WebComponents

extension Identity.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Identity.Router.Routes

        func renderEditPage(
            id: String,
            state: Identity.Edit.FormComponent.State
        )
            async throws
            -> HTMLResponse
        {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderPage(
                content: Identity.Edit.Page(
                    routes: routes,
                    id: id,
                    form: state,
                    permissions: context.currentUserAdminListActions,
                    nonceToken: nonceToken
                )
            )
        }

        func renderValidationError(
            id: String,
            input: Identity.Edit.FormInput?,
            error: ValidationError,
            roleOptions: [Identity.Edit.RoleOption]
        ) async throws -> HTMLResponse {
            var state =
                input.map {
                    Identity.Edit.FormComponent.State.from(
                        name: $0.normalizedName,
                        status: $0.normalizedStatus,
                        roleIds: $0.roleIds,
                        roleOptions: roleOptions
                    )
                } ?? .empty()
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            state.apply(errors: errors)
            return try await renderEditPage(id: id, state: state)
                .withStatus(.unprocessableContent)
        }

        func renderEditError(
            id: String,
            input: Identity.Edit.FormInput?,
            error: Identity.Edit.Error,
            roleOptions: [Identity.Edit.RoleOption]
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
                    status: .conflict,
                    roleOptions: roleOptions
                )
            case .unavailable:
                return try await renderFormError(
                    id: id,
                    input: input,
                    message:
                        "The user identity could not be updated. Please try again.",
                    status: .serviceUnavailable,
                    roleOptions: roleOptions
                )
            }
        }

        func renderSuccess(id: String) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
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
            input: Identity.Edit.FormInput?,
            message: String,
            status: HTTPResponse.Status,
            roleOptions: [Identity.Edit.RoleOption]
        ) async throws -> HTMLResponse {
            var state =
                input.map {
                    Identity.Edit.FormComponent.State.from(
                        name: $0.normalizedName,
                        status: $0.normalizedStatus,
                        roleIds: $0.roleIds,
                        roleOptions: roleOptions
                    )
                } ?? .empty()
            state.error = message
            return try await renderEditPage(id: id, state: state)
                .withStatus(status)
        }

        private func renderStatusPage(
            title: String,
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage user identities",
                content: AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func renderPage<T: Component>(content: T) async throws
            -> HTMLResponse
        {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage user identities",
                content: content
            )
        }
    }
}

extension HTMLResponse {
    fileprivate func withStatus(_ status: HTTPResponse.Status) -> HTMLResponse {
        HTMLResponse(content: content, status: status)
    }
}
