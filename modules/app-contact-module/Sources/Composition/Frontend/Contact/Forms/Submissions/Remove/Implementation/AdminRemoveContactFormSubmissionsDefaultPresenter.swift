import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminRemoveContactFormSubmissionsDefaultPresenter:
    AdminRemoveContactFormSubmissionsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func renderConfirmation(
        formId: String,
        item: AdminContactFormSubmissionItem,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form submission - Feather CMS",
            description: "Remove contact form submission",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: AdminConfirmationDialog(
                state: .init(
                    breadcrumb: breadcrumb(formId: formId, label: "Remove"),
                    title: "Remove contact form submission",
                    message:
                        "Are you sure you want to remove this contact form submission? This action cannot be undone.",
                    details: [
                        .init(prefix: "Submitted: ", value: item.createdAt)
                    ],
                    submitLabel: "Remove submission",
                    actionURL:
                        "/admin/contact/forms/\(formId)/submissions/\(item.id)/remove/",
                    cancelURL: "/admin/contact/forms/\(formId)/submissions/"
                )
            )
        )
    }

    func renderConfirmation(
        formId: String,
        selectedIds: [String],
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form submissions - Feather CMS",
            description: "Remove contact form submissions",
            imagePath: "images/logos/logo.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ListRemoveConfirmation(
                state: .init(
                    breadcrumb: breadcrumb(formId: formId, label: "Remove"),
                    title: "Remove contact form submissions",
                    message:
                        "Are you sure you want to remove the selected contact form submissions? This action cannot be undone.",
                    action:
                        "/admin/contact/forms/\(formId)/submissions/remove/",
                    cancelLink: "/admin/contact/forms/\(formId)/submissions/",
                    selectedIds: selectedIds
                )
            )
        )
    }

    private func breadcrumb(formId: String, label: String)
        -> AdminBreadcrumb.State
    {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(
                label: "Submissions",
                link: "/admin/contact/forms/\(formId)/submissions/"
            ), .init(label: label, link: ""),
        ])
    }
}
