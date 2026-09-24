import FeatherAdmin
import Hummingbird

struct AdminAddNewsletterCampaignDefaultPresenter:
    AdminAddNewsletterCampaignPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func renderPage(
        model: AdminAddNewsletterCampaignModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add campaign",
            content: NewsletterCampaignAddView(
                state: .init(
                    key: model.key,
                    name: model.name,
                    fromEmail: model.fromEmail,
                    error: model.error
                )
            )
        )
    }

    func renderAddError(
        input: NewsletterCampaignAddForm,
        error: AdminAddNewsletterCampaignError,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        switch error {
        case .unauthorized:
            return try await renderStatusPage(
                title: "Session expired",
                message: "Please sign in again to create newsletter campaigns.",
                status: .unauthorized
            )
        case .forbidden:
            return try await renderStatusPage(
                title: "Forbidden",
                message: "Your account cannot create newsletter campaigns.",
                status: .forbidden
            )
        case .conflict:
            return try await renderFormError(
                input: input,
                message: "A newsletter campaign with this key already exists.",
                permissions: permissions,
                status: .conflict
            )
        case .unavailable:
            return try await renderFormError(
                input: input,
                message:
                    "The newsletter campaign could not be created. Please try again.",
                permissions: permissions,
                status: .serviceUnavailable
            )
        }
    }

    private func renderFormError(
        input: NewsletterCampaignAddForm,
        message: String,
        permissions: Set<String>,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderPage(
            model: .init(
                key: input.key,
                name: input.name,
                fromEmail: input.fromEmail,
                error: message
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
            title: "Add campaign",
            content: NewAdminStatusView(
                state: .init(title: title, message: message),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }
}
