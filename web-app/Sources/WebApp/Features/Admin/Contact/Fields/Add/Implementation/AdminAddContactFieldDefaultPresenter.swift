import Hummingbird

struct AdminAddContactFieldDefaultPresenter:
    AdminAddContactFieldPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFieldModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Contact", link: "/admin/contact/"),
            .init(
                label: "Add field",
                link: "/admin/contact/fields/add/"
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
            content: ContactFieldAddView(
                state: .init(
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
