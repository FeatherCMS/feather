import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminListContactFormFieldsDefaultPresenter:
    AdminListContactFormFieldsPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form fields - Feather CMS",
            description: "Manage contact form fields",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormFieldsTable(
                state: .init(
                    formId: formId,
                    fields: fields,
                    search: search,
                    error: error,
                    isEdited: request.hasQueryFlag("edited"),
                    isRemoved: request.hasQueryFlag("removed"),
                    canRemove: permissions.contains(
                        "contact:form-fields:delete"
                    ),
                    breadcrumb: breadcrumb(formId: formId)
                )
            )
        )
    }
    private func breadcrumb(formId: String) -> AdminBreadcrumb.State {
        .init(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(
                label: "Fields",
                link: formId.isEmpty
                    ? "/admin/contact/fields/"
                    : "/admin/contact/forms/\(formId)/items/"
            ),
        ])
    }
}
