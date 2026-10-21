import FeatherValidation
import FeatherWebShared
import FeatherWebAdmin
import Hummingbird
import UserModule
import WebComponents

extension Role.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Role.Router.Routes

        func renderAddPage(state: Role.Add.FormComponent.State) async throws
            -> HTMLResponse
        {
            try await renderAddPage(state: state, status: .ok)
        }

        private func renderAddPage(
            state: Role.Add.FormComponent.State,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderPage(
                content: Role.Add.Page(
                    routes: routes,
                    form: state,
                    nonceToken: nonceToken
                ),
                status: status
            )
        }

        func renderValidationError(
            input: Role.Add.FormInput?,
            error: ValidationError
        ) async throws -> HTMLResponse {
            var state =
                input.map(Role.Add.FormComponent.State.from(input:))
                ?? .addEmpty()
            var errors: [String: String] = [:]
            for failure in error.failures {
                errors[failure.key] = failure.message
            }
            state.apply(errors: errors)
            return try await renderAddPage(
                state: state,
                status: .unprocessableContent
            )
        }

        func renderAddError(
            input: Role.Add.FormInput?,
            error: Role.Add.Error
        ) async throws -> HTMLResponse {
            switch error {
            case .unauthorized: return try await renderUnauthorizedPage()
            case .forbidden: return try await renderForbiddenPage()
            case .conflict:
                return try await renderFormError(
                    input: input,
                    message:
                        "The generated role ID already exists. Please try again.",
                    status: .conflict
                )
            case .unavailable:
                return try await renderFormError(
                    input: input,
                    message:
                        "The user role could not be created. Please try again.",
                    status: .serviceUnavailable
                )
            }
        }

        func renderSuccess() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "User role added successfully."
                )
            )
        }

        func renderUnauthorizedPage() async throws -> HTMLResponse {
            try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to create user roles.",
                status: .unauthorized
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot create user roles.",
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
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage user roles",
                content: content
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func renderFormError(
            input: Role.Add.FormInput?,
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            var state =
                input.map(Role.Add.FormComponent.State.from(input:))
                ?? .addEmpty()
            state.error = message
            return try await renderAddPage(state: state, status: status)
        }

        private func renderStatusPage(
            title: String,
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            try await renderPage(
                content: AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                ),
                status: status
            )
        }
    }
}
