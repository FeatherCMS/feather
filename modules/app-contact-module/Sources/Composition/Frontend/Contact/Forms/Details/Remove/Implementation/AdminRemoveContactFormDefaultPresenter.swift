import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
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
                    path: "/admin/contact/forms/remove/?selectedIds[]=\(id)"
                )
            )
        )
    }

    func renderBulkConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact forms - Feather CMS",
            description: "Remove contact forms",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(label: "Remove", path: ""),
                    title: "Remove contact forms",
                    message:
                        "Are you sure you want to remove the selected contact forms? This action cannot be undone.",
                    action: "/admin/contact/forms/remove/",
                    cancelLink: "/admin/contact/forms/",
                    selectedIds: selectedIds
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
