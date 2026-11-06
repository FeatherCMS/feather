import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird
import NewsletterApplication
import NewsletterModule

extension Campaign.Detail.Presenter {
    struct Default: Interface {
        let request: Request
        let context: AuthenticatedRequestContext
        let renderingEngine: any RenderingEngine
        let routes: Campaign.Router.Routes

        func render(
            id: String,
            item: Campaign.Item,
            error: String?,
            permissions: Set<String>
        ) async throws -> HTMLResponse {
            try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Campaign details",
                content: Campaign.Edit.View(
                    state: .init(
                        id: id,
                        routes: routes,
                        form: .init(
                            key: item.key,
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
                            title: "Edit campaign",
                            description:
                                "Update the campaign settings."
                        )
                    )
                )
            )
        }
    }
}
