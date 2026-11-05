import ContactApplication
import ContactModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension ContactModule.Form.Add.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Form.Router.Routes

        func renderPage(
            item: ContactModule.Form.Details.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add contact form",
                content: ContactModule.Form.Add.Page(
                    state: .init(
                        form: .init(
                            key: item.key,
                            name: item.name,
                            successMessage: item.successMessage,
                            failureMessage: item.failureMessage,
                            submitLabel: item.submitLabel,
                            redirectUrl: item.redirectUrl,
                            fieldIDs: item.selectedFieldIDs,
                            availableFields: item.availableFields,
                            mails: item.mails,
                            error: error,
                            success: nil
                        ),
                        routes: routes
                    )
                )
            )
        }

        func renderAddError(
            item: ContactModule.Form.Details.Item,
            error: Form.Add.Error,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            switch error {
            case .unauthorized:
                return try await renderStatusPage(
                    title: "Session expired",
                    message: "Please sign in again to create contact forms.",
                    status: .unauthorized
                )
            case .forbidden:
                return try await renderStatusPage(
                    title: "Forbidden",
                    message: "Your account cannot create contact forms.",
                    status: .forbidden
                )
            case .conflict:
                return try await renderFormError(
                    item: item,
                    message: "A contact form with this key already exists.",
                    permissions: permissions,
                    status: .conflict
                )
            case .unavailable:
                return try await renderFormError(
                    item: item,
                    message:
                        "The contact form could not be created. Please try again.",
                    permissions: permissions,
                    status: .serviceUnavailable
                )
            }
        }

        private func renderFormError(
            item: ContactModule.Form.Details.Item,
            message: String,
            permissions: Set<String>,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderPage(
                item: item,
                error: message,
                permissions: permissions
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func renderStatusPage(
            title: String,
            message: String,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Add contact form",
                content: AdminStatusView(
                    state: .init(title: title, message: message),
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }
    }
}
