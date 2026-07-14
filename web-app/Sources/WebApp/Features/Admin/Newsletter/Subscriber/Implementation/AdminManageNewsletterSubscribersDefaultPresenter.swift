import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminManageNewsletterSubscribersDefaultPresenter: AdminManageNewsletterSubscribersPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(newsletterId: String, items: [AdminManageNewsletterSubscriberItem], search: String?, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Campaign subscribers - Feather CMS", description: "Manage campaign subscribers", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: NewsletterSubscribersTable(state: .init(newsletterId: newsletterId, isAdded: request.hasQueryFlag("added"), isEdited: request.hasQueryFlag("edited"), isRemoved: request.hasQueryFlag("removed"), items: items, search: search ?? "", canRemove: permissions.contains("newsletter:subscribers:delete"), error: error, breadcrumb: breadcrumb(newsletterId: newsletterId))))
    }

    func renderForm(newsletterId: String, email: String, firstName: String, lastName: String, status: String, isEdit: Bool, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "\(isEdit ? "Edit" : "Add") campaign subscriber - Feather CMS", description: "Manage campaign subscriber", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: NewsletterSubscriberFormView(state: .init(newsletterId: newsletterId, email: email, firstName: firstName, lastName: lastName, status: status, isEdit: isEdit, error: error, breadcrumb: breadcrumb(newsletterId: newsletterId, label: isEdit ? "Edit" : "Add"))))
    }

    func renderRemoveConfirmation(newsletterId: String, subscriberId: String, email: String, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove campaign subscriber - Feather CMS", description: "Remove campaign subscriber", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: NewsletterSubscriberRemoveView(email: email, subscriberId: subscriberId, newsletterId: newsletterId, breadcrumb: breadcrumb(newsletterId: newsletterId, label: "Remove")))
    }

    func renderBulkRemoveConfirmation(newsletterId: String, search: String?, emails: [String], permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove selected subscribers - Feather CMS", description: "Confirm bulk subscriber removal", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(newsletterId: newsletterId), title: "Remove selected subscribers", message: "Are you sure you want to remove these selected subscribers from this campaign? This action cannot be undone.", action: "/admin/newsletters/\(newsletterId)/subscribers/bulk-remove/", cancelLink: "/admin/newsletters/\(newsletterId)/subscribers/", selectedIds: emails)))
    }

    private func breadcrumb(newsletterId: String, label: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Campaigns", link: "/admin/newsletters/"), .init(label: "Subscribers", link: "/admin/newsletters/\(newsletterId)/subscribers/")]
        if let label { links.append(.init(label: label, link: "")) }
        return .init(links: links)
    }
}
