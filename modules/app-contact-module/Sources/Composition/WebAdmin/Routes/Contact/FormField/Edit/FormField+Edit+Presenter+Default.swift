import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Contact.Router.Routes
        func renderPage(
            field: FormField.Model,
            error: String?,
            fieldErrors: [String: String],
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit contact form field",
                content: FormField.Edit.Page(
                    state: .init(
                        field: field,
                        error: error,
                        fieldErrors: fieldErrors,
                        breadcrumb: routes.fieldsBreadcrumb,
                        action: routes.fieldEditPath(field.id)
                    )
                )
            )
        }

        func renderEditError(
            field: FormField.Model,
            error: FormField.Edit.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            switch error {
            case .notFound, .unauthorized, .forbidden:
                return try await renderErrorPage(error: error)
            case .conflict:
                return try await renderFormError(
                    field: field,
                    message:
                        "A contact form field with this key already exists.",
                    permissions: permissions,
                    status: .conflict
                )
            case .unavailable:
                return try await renderFormError(
                    field: field,
                    message:
                        "The contact form field could not be saved. Please try again.",
                    permissions: permissions,
                    status: .serviceUnavailable
                )
            }
        }

        func renderErrorPage(
            error: FormField.Edit.Error
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            let status: HTTPResponse.Status
            switch error {
            case .notFound:
                state = .init(
                    title: "Contact form field not found",
                    message: "This contact form field may have been removed."
                )
                status = .notFound
            case .unauthorized:
                state = .init(
                    title: "Session expired",
                    message: "Please sign in again."
                )
                status = .unauthorized
            case .forbidden:
                state = .init(
                    title: "Forbidden",
                    message: "Your account cannot edit contact form fields."
                )
                status = .forbidden
            case .conflict:
                state = .init(
                    title: "Unable to save changes",
                    message:
                        "A contact form field with this key already exists."
                )
                status = .conflict
            case .unavailable:
                state = .init(
                    title: "Contact form field unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
                status = .serviceUnavailable
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit contact form field",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }

        func renderForbiddenPage() async throws -> HTMLResponse {
            try await renderErrorPage(error: .forbidden)
        }

        private func renderFormError(
            field: FormField.Model,
            message: String,
            permissions: Set<String>,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderPage(
                field: field,
                error: message,
                fieldErrors: [:],
                permissions: permissions
            )
            return HTMLResponse(content: page.content, status: status)
        }
    }
}
