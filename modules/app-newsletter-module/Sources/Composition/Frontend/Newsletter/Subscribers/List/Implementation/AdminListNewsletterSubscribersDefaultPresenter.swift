import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminListNewsletterSubscribersDefaultPresenter:
    AdminListNewsletterSubscribersPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        model: AdminNewsletterSubscribersListModel,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Subscribers",
            description: "Manage campaign subscribers",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminNewsletterSubscribersListView(
                model: model,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Subscribers", link: ""),
                ]),
                error: error,
                canRemove: permissions.contains("newsletter:subscribers:delete")
            )
        )
    }
}
