import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminViewNewsletterCampaignDefaultPresenter:
    AdminViewNewsletterCampaignPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine
    func render(
        item: AdminNewsletterCampaignItem,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Campaign details",
            content: NewsletterCampaignEditPage(
                state: .init(
                    id: item.id,
                    form: .init(
                        key: item.id,
                        name: item.name,
                        fromEmail: item.fromEmail,
                        error: error,
                        success: nil
                    ),
                    isDetails: true,
                    permissions: NewAdminListActions(
                        Set(permissions.map(PermissionKey.init))
                    )
                )
            )
        )
    }
}
