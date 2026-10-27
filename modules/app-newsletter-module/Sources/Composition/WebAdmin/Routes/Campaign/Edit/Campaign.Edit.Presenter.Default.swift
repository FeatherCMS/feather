import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Edit.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            item: Campaign.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit campaign",
                content: Campaign.Edit.View(
                    state: .init(
                        id: item.id,
                        routes: routes,
                        form: .init(
                            key: item.key,
                            name: item.name,
                            fromEmail: item.fromEmail,
                            error: error,
                            success: nil
                        ),
                        isDetails: false,
                        permissions: AdminListActions(
                            Set(permissions.map(PermissionKey.init))
                        ),
                        pageHeader: .primary(
                            title: "Edit campaign",
                            description:
                                "Update the campaign settings."
                        )
                    )
                )
            )
        }

        func renderEditError(
            id: String,
            item: Campaign.Item,
            error: Campaign.Edit.WebError,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            switch error {
            case .notFound, .unauthorized, .forbidden:
                return try await renderErrorPage(error: error)
            case .conflict:
                return try await renderFormError(
                    item: item,
                    message:
                        "A newsletter campaign with this key already exists.",
                    permissions: permissions,
                    status: .conflict
                )
            case .unavailable:
                return try await renderFormError(
                    item: item,
                    message:
                        "The newsletter campaign could not be saved. Please try again.",
                    permissions: permissions,
                    status: .serviceUnavailable
                )
            }
        }

        func renderErrorPage(
            error: Campaign.Edit.WebError
        ) async throws -> HTMLResponse {
            let state: AdminStatusView.State
            let status: HTTPResponse.Status
            switch error {
            case .notFound:
                state = .init(
                    title: "Newsletter campaign not found",
                    message: "This newsletter campaign may have been removed."
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
                    message: "Your account cannot edit newsletter campaigns."
                )
                status = .forbidden
            case .conflict:
                state = .init(
                    title: "Unable to save changes",
                    message:
                        "A newsletter campaign with this key already exists."
                )
                status = .conflict
            case .unavailable:
                state = .init(
                    title: "Newsletter campaign unavailable",
                    message:
                        "The request could not be completed. Please try again."
                )
                status = .serviceUnavailable
            }
            let page = try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Edit campaign",
                content: AdminStatusView(
                    state: state,
                    icon: FeatherIcons.alertCircle()
                )
            )
            return HTMLResponse(content: page.content, status: status)
        }

        private func renderFormError(
            item: Campaign.Item,
            message: String,
            permissions: Set<String>,
            status: HTTPResponse.Status
        ) async throws -> HTMLResponse {
            let page = try await render(
                item: item,
                error: message,
                permissions: permissions
            )
            return HTMLResponse(content: page.content, status: status)
        }
    }
}
