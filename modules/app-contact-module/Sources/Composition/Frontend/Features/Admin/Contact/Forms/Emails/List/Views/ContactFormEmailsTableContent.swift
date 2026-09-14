import FeatherAdmin
import FeatherContracts
import ContactContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormEmailsTableContent: Component {
    let id: String
    let mails: [AdminContactFormEmail]
    let permissions: NewAdminListActions


    func html(context: inout RenderContext) -> Div {
        let path = ContactAdminRoutes.formEmails(RouterPath(id)).description
                let pageState = NewAdminListPageState(page: 1, pageSize: max(mails.count, 1), total: mails.count)
        return context.render(
            NewAdminList(
                table: {
                    if mails.isEmpty {
                        context.render(NewAdminListEmptyState(message: "No email definitions yet.", icon: FeatherIcons.mail(), action: {
                            if permissions.allows(ContactPermissions.Mails.create) { context.render(NewAdminButton("Add email", href: ContactAdminRoutes.formEmailAdd(RouterPath(id)).description)) }
                        }))
                    }
                    else {
                        let canDelete = permissions.allows(ContactPermissions.Mails.delete)
                        context.render(NewAdminListSelectionForm(
                            state: .init(action: ContactAdminRoutes.formEmailRemove(RouterPath(id)).description, pageState: pageState, search: "", button: .init("Remove selected", style: .destructive), isEnabled: canDelete),
                            table: context.render(NewAdminListShell(
                                layout: .init(name: "contact-form-emails", columns: [.fraction(1), .fraction(1), .fraction(1), .fixed(220)]), hasSelection: canDelete,
                                table: Table {
                                    Thead { Tr { if canDelete { context.render(NewAdminListSelectAllCheckbox()) }; Th("From"); Th("To"); Th("Subject"); Th("Actions") } }
                                    Tbody {
                                        for mail in mails {
                                            Tr {
                                                if canDelete { context.render(NewAdminListRowCheckbox(id: mail.id)) }
                                                Td(mail.mailFrom).data("label", "From")
                                                Td(mail.mailTo).data("label", "To")
                                                Td(mail.subject).data("label", "Subject")
                                                context.render(NewAdminListRowActions(label: "Actions", actions: [
                                                    .init("Edit", href: ContactAdminRoutes.formEmailEdit(formID: RouterPath(id), emailID: RouterPath(mail.id)).description, style: .ghost(.secondary), permission: ContactPermissions.Mails.update),
                                                    .init("Remove", href: NewAdminLocation.remove(path: ContactAdminRoutes.formEmailRemove(RouterPath(id)).description, ids: [mail.id], returnTo: path), style: .destructive, permission: ContactPermissions.Mails.delete),
                                                ], permissions: permissions))
                                            }
                                        }
                                    }
                                }.class("cms-table", "action-table").if(canDelete) { $0.class("select-table") }
                            ))
                        ))
                    }
                },
                toolbar: { if permissions.allows(ContactPermissions.Mails.create) { context.render(NewAdminListToolbar { context.render(NewAdminButton("Add email", href: ContactAdminRoutes.formEmailAdd(RouterPath(id)).description)) }) } }
            )
        )
    }
}
