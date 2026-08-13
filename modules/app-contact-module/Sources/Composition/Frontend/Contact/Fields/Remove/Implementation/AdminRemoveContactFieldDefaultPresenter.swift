import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFieldDefaultPresenter:
    AdminRemoveContactFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderConfirmation(
        fieldId: String,
        label: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form field - Feather CMS",
            description: "Remove contact form field",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFieldRemoveView(
                fieldId: fieldId,
                label: label,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Contact", link: "/admin/contact/"),
                    .init(label: "Fields", link: ""),
                    .init(label: "Remove", link: ""),
                ])
            )
        )
    }

    func renderBulkConfirmation(
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact fields - Feather CMS",
            description: "Remove contact fields",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListBulkRemoveConfirmation(
                state: .init(
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Contact", link: "/admin/contact/"),
                        .init(label: "Fields", link: "/admin/contact/fields/"),
                        .init(label: "Remove", link: ""),
                    ]),
                    title: "Remove contact fields",
                    message:
                        "Are you sure you want to remove the selected contact fields? This action cannot be undone.",
                    action: "/admin/contact/fields/remove/",
                    cancelLink: "/admin/contact/fields/",
                    selectedIds: selectedIds
                )
            )
        )
    }
}
