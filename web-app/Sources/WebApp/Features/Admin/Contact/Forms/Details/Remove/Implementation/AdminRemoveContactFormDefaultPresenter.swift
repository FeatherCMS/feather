import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveContactFormDefaultPresenter: AdminRemoveContactFormPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderConfirmation(id: String, name: String, permissions: Set<String>)
        -> HTMLResponse
    {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form - Feather CMS",
            description: "Remove contact form",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormRemoveView(
                id: id,
                name: name,
                breadcrumb: breadcrumb(
                    label: "Remove",
                    path: "/admin/contact/forms/\(id)/remove/"
                )
            )
        )
    }

    private func breadcrumb(label: String, path: String)
        -> AdminBreadcrumb.State
    {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(label: label, link: path),
        ])
    }
}
