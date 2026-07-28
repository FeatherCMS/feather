import Hummingbird

struct AdminAddContactFormFieldDefaultPresenter:
    AdminAddContactFormFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(
                label: "Add field",
                link: model.formId.isEmpty
                    ? "/admin/contact/fields/add/"
                    : "/admin/contact/forms/\(model.formId)/items/add/"
            ),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add contact form field - Feather CMS",
            description: "Add contact form field - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormFieldAddView(
                state: .init(
                    formId: model.formId,
                    key: model.key,
                    type: model.type,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired,
                    position: model.position,
                    error: model.error,
                    breadcrumb: breadcrumb
                )
            )
        )
    }
}
