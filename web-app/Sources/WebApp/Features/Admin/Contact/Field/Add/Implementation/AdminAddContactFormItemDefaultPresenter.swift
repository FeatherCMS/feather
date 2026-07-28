import Hummingbird

struct AdminAddContactFormItemDefaultPresenter: AdminAddContactFormItemPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFormItemModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(label: "Forms", link: "/admin/contact/forms/"),
            .init(
                label: "Add item",
                link: "/admin/contact/forms/\(model.formId)/items/add/"
            ),
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add contact form item - Feather CMS",
            description: "Add contact form item - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: ContactFormItemAddView(
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
