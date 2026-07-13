import HTML
import Hummingbird
import SGML
import WebStandards

struct AdminManageContactFormSubmissionsDefaultPresenter: AdminManageContactFormSubmissionsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(formId: String, items: [AdminManageContactFormSubmissionRow], error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact form submissions - Feather CMS", description: "Track contact form submissions", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormSubmissionsTable(state: .init(formId: formId, items: items, error: error, breadcrumb: breadcrumb(formId: formId))))
    }

    func renderDetail(formId: String, item: AdminManageContactFormSubmissionRow, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact form submission - Feather CMS", description: "View contact form submission", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormSubmissionDetailView(state: .init(formId: formId, item: item, error: error, isEdited: request.hasQueryFlag("edited"), breadcrumb: breadcrumb(formId: formId, label: "Details"))))
    }

    private func breadcrumb(formId: String, label: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Forms", link: "/admin/contact/forms/"), .init(label: "Submissions", link: "/admin/contact/forms/\(formId)/submissions/")]
        if let label { links.append(.init(label: label, link: "")) }
        return .init(links: links)
    }
}
