import FeatherWebAdmin
import FeatherWebShared
import FeatherModuleKit
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
        let actions = AdminListActions(
            Set(permissions.map(PermissionKey.init))
        )
        if let error {
            return try await renderingEngine.renderAdminPage(
                request: request,
                context: context,
                title: "Subscribers",
                content: AdminStatusView(
                    state: .init(
                        title: "Subscribers unavailable",
                        message: error
                    ),
                    icon: FeatherIcons.alertCircle()
                )
            )
        }
        return try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Subscribers",
            content: NewsletterSubscribersTable(
                model: model,
                permissions: actions
            )
        )
    }

    func renderDetailsPage(
        item: AdminNewsletterSubscriberListItem,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Subscriber details",
            content: NewsletterSubscriberDetails(
                item: item,
                permissions: AdminListActions(
                    Set(permissions.map(PermissionKey.init))
                )
            )
        )
    }

    func renderDetailsErrorPage(
        message: String,
        status: HTTPResponse.Status
    ) async throws -> HTMLResponse {
        let page = try await renderingEngine.renderAdminPage(
            request: request,
            context: context,
            title: "Subscriber details",
            content: AdminStatusView(
                state: .init(
                    title: "Subscriber unavailable",
                    message: message
                ),
                icon: FeatherIcons.alertCircle()
            )
        )
        return HTMLResponse(content: page.content, status: status)
    }
}
