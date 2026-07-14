import Hummingbird

struct AdminManageContactFormsDefaultPresenter: AdminManageContactFormsPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderList(items: [AdminManageContactFormItem], search: String, isAdded: Bool, isEdited: Bool, isRemoved: Bool, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Contact forms - Feather CMS", description: "Manage contact forms", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormTable(state: .init(isAdded: isAdded, isEdited: isEdited, isRemoved: isRemoved, items: items, search: search, canRemove: permissions.contains("contact:forms:delete"), breadcrumb: breadcrumb())))
    }

    func renderBulkRemoveConfirmation(selectedIds: [String], permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact forms - Feather CMS", description: "Remove contact forms", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ListBulkRemoveConfirmation(state: .init(breadcrumb: breadcrumb(label: "Remove", path: "/admin/contact/forms/bulk-remove/"), title: "Remove contact forms", message: "Are you sure you want to remove the selected contact forms? This action cannot be undone.", action: "/admin/contact/forms/bulk-remove/", cancelLink: "/admin/contact/forms/", selectedIds: selectedIds)))
    }

    func renderEdit(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse {
        let form = ContactFormForm.State(name: item.name, successMessage: item.successMessage, failureMessage: item.failureMessage, redirectUrl: item.redirectUrl, fieldIDs: item.selectedFieldIDs, availableFields: item.availableFields, mails: item.mails, error: error, success: nil)
        if item.id.isEmpty {
            return renderEngine.renderAdminPage(request: request, title: "Add contact form - Feather CMS", description: "Add contact form", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormAdd(state: .init(form: form, breadcrumb: breadcrumb(label: "Add", path: "/admin/contact/forms/add/"))))
        }
        return renderEngine.renderAdminPage(request: request, title: "Edit contact form - Feather CMS", description: "Edit contact form", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormEdit(state: .init(id: item.id, isEdited: false, form: form, breadcrumb: breadcrumb(label: "Edit", path: "/admin/contact/forms/\(item.id)/edit/"))))
    }

    func renderEmails(item: AdminManageContactFormItem, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Contact form emails - Feather CMS",
            description: "Manage contact form emails",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: ContactFormEmails(
                id: item.id,
                mails: item.mails,
                breadcrumb: breadcrumb(label: "Emails", path: "/admin/contact/forms/\(item.id)/emails/"),
                error: error
            )
        )
    }

    func renderEmailAdd(formId: String, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Add contact form email - Feather CMS", description: "Add contact form email", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormMailAdd(formId: formId, mail: .init(id: "", mailFrom: "", mailTo: "", subject: "", additionalHeaders: "", messageBody: ""), breadcrumb: breadcrumb(label: "Add email", path: "/admin/contact/forms/\(formId)/emails/add/"), error: error))
    }

    func renderEmailEdit(formId: String, mail: AdminManageContactFormMail, error: String?, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Edit contact form email - Feather CMS", description: "Edit contact form email", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormMailEdit(formId: formId, mail: mail, breadcrumb: breadcrumb(label: "Edit email", path: "/admin/contact/forms/\(formId)/emails/\(mail.id)/edit/"), error: error))
    }

    func renderEmailRemove(formId: String, mail: AdminManageContactFormMail, permissions: Set<String>) -> HTMLResponse {
        renderEngine.renderAdminPage(request: request, title: "Remove contact form email - Feather CMS", description: "Remove contact form email", imagePath: "images/puppy.png", sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions), content: ContactFormMailRemove(formId: formId, mail: mail, breadcrumb: breadcrumb(label: "Remove email", path: "/admin/contact/forms/\(formId)/emails/\(mail.id)/remove/")))
    }

    func renderRemoveConfirmation(
        id: String,
        name: String,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Remove contact form - Feather CMS",
            description: "Remove contact form",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(request: request, permissions: permissions),
            content: ContactFormRemoveView(
                id: id,
                name: name,
                breadcrumb: breadcrumb(label: "Remove", path: "/admin/contact/forms/\(id)/remove/")
            )
        )
    }

    private func breadcrumb(label: String? = nil, path: String? = nil) -> AdminBreadcrumb.State {
        var links: [AdminBreadcrumb.State.Link] = [.init(label: "Admin", link: "/admin/"), .init(label: "Contact", link: "/admin/contact/"), .init(label: "Forms", link: "/admin/contact/forms/")]
        if let label, let path { links.append(.init(label: label, link: path)) }
        return .init(links: links)
    }
}
