import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectApplication
import RedirectModule
import WebComponents

extension RedirectModule.Rule.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: RedirectModule.Rule.Router.Routes

        func renderAddPage(
            state: RedirectModule.Rule.Add.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            try await renderPage(
                content: RedirectModule.Rule.Add.Page(
                    form: state,
                    nonceToken: await AdminNonceStore.shared.issue(
                        sessionToken: context.sessionToken
                    ),
                    routes: routes
                ),
                status: .ok
            )
        }

        func renderValidationError(
            input: RedirectModule.Rule.Add.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse {
            var state =
                input.map(RedirectModule.Rule.Add.Form.State.from(input:))
                ?? .empty()
            state.apply(
                errors: Dictionary(
                    uniqueKeysWithValues: error.failures.map {
                        ($0.key, $0.message)
                    }
                )
            )
            return try await renderAddPage(
                state: state,
                permissions: context.currentUserAdminListActions
            )
            .withStatus(.unprocessableContent)
        }

        func renderAddError(
            input: RedirectModule.Rule.Add.Form.Input?,
            error: RedirectModule.Rule.Add.Error
        ) async throws -> HTMLResponse {
            switch error {
            case .unauthorized:
                return try await renderStatusPage(
                    title: "Session expired",
                    message: "Please sign in again to add redirect rules.",
                    status: .unauthorized
                )
            case .forbidden:
                return try await renderStatusPage(
                    title: "Forbidden",
                    message: "Your account cannot add redirect rules.",
                    status: .forbidden
                )
            case .conflict:
                return try await renderFormError(
                    input: input,
                    message: "A redirect rule with this source already exists.",
                    status: .conflict
                )
            case .unavailable:
                return try await renderFormError(
                    input: input,
                    message:
                        "The redirect rule could not be added. Please try again.",
                    status: .serviceUnavailable
                )
            }
        }

        func renderSuccess() -> Response {
            AdminNotificationFlash.redirect(
                to: routes.list.path,
                notification: .init(
                    title: "Added",
                    message: "Redirect rule added successfully."
                )
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot add redirect rules.",
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
            input: RedirectModule.Rule.Add.Form.Input?,
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            var state =
                input.map(RedirectModule.Rule.Add.Form.State.from(input:))
                ?? .empty()
            state.error = message
            return try await renderAddPage(
                state: state,
                permissions: context.currentUserAdminListActions
            )
            .withStatus(status)
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

        private func renderPage<T: Component>(
            content: T,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Manage redirect rules",
                content: content
            )
            return HTMLResponse(content: page.content, status: status)
        }
    }
}

extension HTMLResponse {
    fileprivate func withStatus(_ status: HTTPResponse.Status) -> HTMLResponse {
        HTMLResponse(content: content, status: status)
    }
}
