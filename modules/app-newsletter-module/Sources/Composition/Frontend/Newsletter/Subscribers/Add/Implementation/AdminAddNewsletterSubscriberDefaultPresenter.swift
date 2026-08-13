import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddNewsletterSubscriberDefaultPresenter:
    AdminAddNewsletterSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        model: AdminAddNewsletterSubscriberModel,
        isAdded: Bool,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Add subscriber - Feather CMS",
            description: "Add newsletter subscriber",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminAddNewsletterSubscriberView(
                model: model,
                isAdded: isAdded,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Newsletter", link: "/admin/newsletters/"),
                    .init(
                        label: "Subscribers",
                        link: "/admin/newsletters/subscribers/"
                    ),
                    .init(label: "Add", link: ""),
                ])
            )
        )
    }
}
