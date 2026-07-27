import Hummingbird

struct AdminAddContactNewsletterDefaultPresenter: AdminAddContactNewsletterPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(model: AdminAddContactNewsletterModel, permissions: Set<String>) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Add", link: "/admin/newsletters/add/")
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add campaign - Feather CMS",
            description: "Add campaign - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: ContactNewsletterAddView(state: .init(name: model.name, fromEmail: model.fromEmail, error: model.error, breadcrumb: breadcrumb))
        )
    }
}
