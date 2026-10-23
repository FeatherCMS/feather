import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
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
        item: Campaign.Item,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
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
                    permissions: AdminListActions(
                        Set(permissions.map(PermissionKey.init))
                    ),
                    pageHeader: .primary(
                        title: "Campaign details",
                        description: "View this newsletter campaign."
                    )
                )
            )
        )
    }
}
