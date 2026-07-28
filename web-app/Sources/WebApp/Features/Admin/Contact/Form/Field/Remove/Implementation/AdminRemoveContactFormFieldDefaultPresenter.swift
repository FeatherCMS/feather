import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminRemoveContactFormFieldDefaultPresenter:
    AdminRemoveContactFormFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderConfirmation(
        formId: String,
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
            content: ContactFormFieldRemoveView(
                formId: formId,
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
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        let basePath =
            formId.isEmpty
            ? "/admin/contact/fields"
            : "/admin/contact/forms/\(formId)/items"
        return renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form fields - Feather CMS",
            description: "Remove contact form fields",
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
                        .init(label: "Fields", link: ""),
                        .init(label: "Remove", link: ""),
                    ]),
                    title: "Remove contact form fields",
                    message:
                        "Are you sure you want to remove the selected contact form fields? This action cannot be undone.",
                    action: "\(basePath)/bulk-remove/",
                    cancelLink: "\(basePath)/",
                    selectedIds: selectedIds
                )
            )
        )
    }
}
