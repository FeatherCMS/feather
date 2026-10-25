import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import RedirectModule
import RedirectApplication
import WebComponents

extension RedirectModule.Rule.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: RedirectModule.Rule.Router.Routes

        func renderEditPage(
            id: String,
            state: RedirectModule.Rule.Edit.Form.State,
            permissions: AdminListActions
        ) async throws -> HTMLResponse {
            let nonceToken = await AdminNonceStore.shared.issue(
                sessionToken: context.sessionToken
            )
            return try await renderPage(
                content: RedirectModule.Rule.Edit.Page(
                    id: id,
                    form: state,
                    nonceToken: nonceToken,
                    permissions: permissions,
                    routes: routes
                ),
                status: .ok
            )
        }

        func renderValidationError(
            id: String,
            input: RedirectModule.Rule.Edit.Form.Input?,
            error: ValidationError
        ) async throws -> HTMLResponse {
            var state =
                input.map(RedirectModule.Rule.Edit.Form.State.from(input:))
                ?? .empty()
            var errors: [String: String] = [:]
            for failure in error.failures {
                precondition(
                    errors.updateValue(failure.message, forKey: failure.key)
                        == nil
                )
            }
            state.apply(
                errors: errors
            )
            return try await renderEditPage(
                id: id,
                state: state,
                permissions: context.currentUserAdminListActions
            )
            .withStatus(.unprocessableContent)
        }

        func renderEditError(
            id: String,
            input: RedirectModule.Rule.Edit.Form.Input?,
            error: RedirectModule.Rule.Edit.Interactor.Error
        ) async throws -> HTMLResponse {
            switch error {
            case .notFound:
                return try await renderStatusPage(
                    title: "Redirect rule not found",
                    message: "This redirect rule may have been removed.",
                    status: .notFound
                )
            case .unauthorized:
                return try await renderStatusPage(
                    title: "Session expired",
                    message: "Please sign in again to edit redirect rules.",
                    status: .unauthorized
                )
            case .forbidden: return try await renderForbiddenPage()
            case .conflict:
                return try await renderFormError(
                    input: input,
                    message: "A redirect rule with this source already exists.",
                    status: .conflict,
                    id: id
                )
            case .unavailable:
                return try await renderFormError(
                    input: input,
                    message:
                        "The redirect rule could not be updated. Please try again.",
                    status: .serviceUnavailable,
                    id: id
                )
            }
        }

        func renderSuccess(id: String) -> Response {
            AdminNotificationFlash.redirect(
                to: routes.editPath(id),
                notification: .init(
                    title: "Saved",
                    message: "Redirect rule updated successfully."
                )
            )
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot edit redirect rules.",
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
            input: RedirectModule.Rule.Edit.Form.Input?,
            message: String,
            status: HTTPResponse.Status,
            id: String
        ) async throws -> HTMLResponse {
            var state =
                input.map(RedirectModule.Rule.Edit.Form.State.from(input:))
                ?? .empty()
            state.error = message
            return try await renderEditPage(
                id: id,
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
