import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFieldDefaultPresenter:
    AdminAddContactFieldPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form field",
            content: ContactFieldAddPage(
                state: .init(
                    key: model.key,
                    type: model.type,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired,
                    position: model.position,
                    error: model.error,
                    fieldErrors: model.fieldErrors,
                    breadcrumb: ContactAdminRoutes.fieldsBreadcrumb
                )
            )
        )
    }

    func renderAddError(
        input: ContactFieldFormInput,
        error: AdminAddContactFieldError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to create contact form fields.",
                status: .unauthorized
            )
        case .forbidden:
            return try await renderForbiddenPage()
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A contact form field with this key already exists.",
                permissions: permissions,
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The contact form field could not be created. Please try again.",
                permissions: permissions,
                status: .serviceUnavailable
            )
        }
    }

    func renderForbiddenPage() async throws -> HTMLResponse {
        try await renderStatusPage(
            title: "Forbidden",
            message: "Your account cannot create contact form fields.",
            status: .forbidden
        )
    }

    private func renderFormError(
        input: ContactFieldFormInput,
        message: String,
        permissions: Set<String>,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderPage(
            model: .init(
                key: input.key,
                type: input.type,
                label: input.label,
                allowedValues: input.allowedValues,
                isRequired: input.isRequiredValue,
                position: input.position,
                error: message,
                fieldErrors: [:]
            ),
            permissions: permissions
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderStatusPage(
        title: String,
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form field",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }
}
