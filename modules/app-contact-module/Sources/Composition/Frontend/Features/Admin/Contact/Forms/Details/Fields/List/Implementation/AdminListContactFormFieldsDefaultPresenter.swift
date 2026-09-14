import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminListContactFormFieldsDefaultPresenter:
    AdminListContactFormFieldsPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderList(
        formId: String,
        fields: [AdminContactFormFieldRow],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderingEngine.renderAdminPage(
            request: request,
            title: "Contact form fields",
            description: "Manage contact form fields",
            imagePath: "images/logos/logo.png",
            sidebarState: renderingEngine.adminSidebarState(
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
        ])
    }
}
