import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormDefaultPresenter: AdminEditContactFormPresenter {
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderPage(
            key: item.key,
            item: item,
            error: error,
            permissions: permissions
        )
    }

    private func renderPage(
        key: String,
        item: AdminContactFormDetailsItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form",
            content: ContactFormEditPage(
                state: .init(
                    key: key,
                    isReadOnly: !permissions.contains("contact:forms:update"),
                    form: .init(
                        key: item.key,
                        name: item.name,
                        successMessage: item.successMessage,
                        failureMessage: item.failureMessage,
                        redirectUrl: item.redirectUrl,
                        fieldIDs: item.selectedFieldIDs,
                        availableFields: item.availableFields,
                        mails: item.mails,
                        error: error,
                        success: nil
                    ),
                    breadcrumb: ContactAdminRoutes.formsBreadcrumb
                )
            )
        )
    }

    func renderEditError(
        key: String,
        item: AdminContactFormDetailsItem,
        error: AdminEditContactFormError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound, .unauthorized, .forbidden:
            return try await renderErrorPage(error: error)
        case .conflict:
            return try await renderFormError(
                key: key,
                item: item,
                message: "A contact form with this key already exists.",
                permissions: permissions,
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                key: key,
                item: item,
                message: "The contact form could not be saved. Please try again.",
                permissions: permissions,
                status: .serviceUnavailable
            )
        }
    }

    func renderErrorPage(
        error: AdminEditContactFormError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
        let status: HTTPResponse.Status
        switch error {
        case .notFound:
            state = .init(
                title: "Contact form not found",
                message: "This contact form may have been removed."
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
                message: "Your account cannot edit contact forms."
            )
            status = .forbidden
        case .conflict:
            state = .init(
                title: "Unable to save changes",
                message: "A contact form with this key already exists."
            )
            status = .conflict
        case .unavailable:
            state = .init(
                title: "Contact form unavailable",
                message: "The request could not be completed. Please try again."
            )
            status = .serviceUnavailable
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit contact form",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        key: String,
        item: AdminContactFormDetailsItem,
        message: String,
        permissions: Set<String>,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderPage(
            key: key,
            item: item,
            error: message,
            permissions: permissions
        )
        return HTMLResponse(content: page.content, status: status)
    }
}
