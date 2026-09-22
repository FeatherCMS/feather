import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditNewsletterCampaignDefaultPresenter:
    AdminEditNewsletterCampaignPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await render(
            id: item.id,
            item: item,
            error: error,
            permissions: permissions
        )
    }

    private func render(
        id: String,
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit campaign",
            content: NewsletterCampaignEditPage(
                state: .init(
                    id: id,
                    form: .init(
                        key: item.id,
                        name: item.name,
                        fromEmail: item.fromEmail,
                        error: error,
                        success: nil
                    ),
                    isDetails: false
                )
            )
        )
    }

    func renderEditError(
        id: String,
        item: AdminNewsletterCampaignItem,
        error: AdminEditNewsletterCampaignError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        switch error {
        case .notFound, .unauthorized, .forbidden:
            return try await renderErrorPage(error: error)
        case .conflict:
            return try await renderFormError(
                id: id,
                item: item,
                message: "A newsletter campaign with this key already exists.",
                permissions: permissions,
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                id: id,
                item: item,
                message:
                    "The newsletter campaign could not be saved. Please try again.",
                permissions: permissions,
                status: .serviceUnavailable
            )
        }
    }

    func renderErrorPage(
        error: AdminEditNewsletterCampaignError
    ) async throws -> HTMLResponse {
        let state: NewAdminStatusView.State
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
                message: "A newsletter campaign with this key already exists."
            )
            status = .conflict
        case .unavailable:
            state = .init(
                title: "Newsletter campaign unavailable",
                message: "The request could not be completed. Please try again."
            )
            status = .serviceUnavailable
        }
        let page = try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Edit campaign",
            content: NewAdminStatusView(
                state: state,
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }

    private func renderFormError(
        id: String,
        item: AdminNewsletterCampaignItem,
        message: String,
        permissions: Set<String>,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await render(
            id: id,
            item: item,
            error: message,
            permissions: permissions
        )
        return HTMLResponse(content: page.content, status: status)
    }
}
