import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminNewsletterSubscribersDirectoryDefaultPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func render(model: AdminNewsletterSubscribersDirectoryModel, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Subscribers - Feather CMS",
            description: "Manage campaign subscribers",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: AdminNewsletterSubscribersDirectoryView(
                model: model,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Campaigns", link: "/admin/newsletters/"),
                    .init(label: "Subscribers", link: "")
                ]),
                error: error
            )
        )
    }
}
