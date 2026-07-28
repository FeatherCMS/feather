import HTML
import SGML
import WebStandards

struct ContactFormEmails: Component {
    let id: String
    let mails: [AdminContactFormEmail]
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func content() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: id, active: .emails)
            AdminBreadcrumb(state: breadcrumb)
            H1("Contact form emails")
            if let error { P(error).class("error") }
            Div {
                AdminNavigationButton(
                    "Add email",
                    href: "/admin/contact/forms/\(id)/emails/add/"
                )
            }
            .class("button-row")
            Br()
            Br()
            if mails.isEmpty {
                P("No emails configured yet.")
            }
            else {
                ListTableShell(
                    table: Table {
                        Thead {
                            Tr {
                                Th("From")
                                Th("To")
                                Th("Subject")
                                Th("Actions")
                            }
                        }
                        Tbody {
                            for mail in mails {
                                Tr {
                                    Td(mail.mailFrom).data("label", "From")
                                    Td(mail.mailTo).data("label", "To")
                                    Td(mail.subject).data("label", "Subject")
                                    ListTableRowActions(
                                        state: .init(
                                            label: "Actions",
                                            actions: [
                                                .init(
                                                    title: "Edit",
                                                    href:
                                                        "/admin/contact/forms/\(id)/emails/\(mail.id)/edit/",
                                                    className: "edit",
                                                    permission:
                                                        "contact:forms:update"
                                                ),
                                                .init(
                                                    title: "Remove",
                                                    href:
                                                        "/admin/contact/forms/\(id)/emails/\(mail.id)/remove/",
                                                    className: "delete",
                                                    permission:
                                                        "contact:forms:update"
                                                ),
                                            ],
                                            permissions: [
                                                "contact:forms:update"
                                            ]
                                        )
                                    )
                                }
                            }
                        }
                    }
                    .class("cms-table", "action-table")
                )
            }
        }
        .class("cms-section")
    }
}
