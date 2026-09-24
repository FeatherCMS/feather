import FeatherAdmin
import FeatherContracts
import Hummingbird

struct AdminListNewsletterSubscribersDefaultPresenter:
    AdminListNewsletterSubscribersPresenter
{
    let request: Request
    let context: AuthenticatedRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminNewsletterSubscribersListModel,
        error: String?,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        let actions = NewAdminListActions(
            Set(permissions.map(PermissionKey.init))
        )
        if let error {
            return try await renderingEngine.renderNewAdminPage(
                request: request,
                context: context,
                title: "Subscribers",
                content: NewAdminStatusView(
                    state: .init(
                        title: "Subscribers unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Subscribers",
            content: NewsletterSubscribersTable(
                model: model,
                permissions: actions
            )
        )
    }
}
