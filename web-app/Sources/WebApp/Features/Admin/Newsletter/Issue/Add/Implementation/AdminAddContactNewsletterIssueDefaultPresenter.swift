import Hummingbird

struct AdminAddContactNewsletterIssueDefaultPresenter: AdminAddContactNewsletterIssuePresenter {
    let request: Request
    let renderEngine: any RenderingEngine
    func renderPage(model: AdminAddContactNewsletterIssueModel, permissions: Set<String>) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Campaign", link: "/admin/newsletters/"),
            .init(label: "Add issue", link: "/admin/newsletters/\(model.newsletterId)/issues/add/")
        ])
        return renderEngine.renderAdminPage(
            request: request,
            title: "Add campaign issue - Feather CMS",
            description: "Add campaign issue - Feather CMS",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: ContactNewsletterIssueAddView(state: .init(subject: model.subject, content: model.content, scheduledAt: model.scheduledAt, newsletterId: model.newsletterId, error: model.error, breadcrumb: breadcrumb))
        )
    }
}
