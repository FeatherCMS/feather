import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormEmails: Leaf {
    let id: String
    let mails: [AdminContactFormEmail]
    let canRemove: Bool
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html() -> some BasicTag {
        Section {
            AdminContactFormTabs(formId: id, active: .emails).html()
            AdminBreadcrumb(state: breadcrumb).html()
            H1("Contact form emails")
            if let error { P(error).class("error") }
            Div {
                AdminNavigationButton(
                    "Add email",
                    href: "/admin/contact/forms/\(id)/emails/add/"
                ).html()
            }
            .class("button-row")
            Br()
            Br()
            if mails.isEmpty {
                P("No emails configured yet.")
            }
            else {
                ListTableRemoveForm(
                    state: .init(
                        action: "/admin/contact/forms/\(id)/emails/remove/",
                        page: 1,
                        search: "",
                        canRemove: canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        ListTableSelectAllCheckbox().html()
                                    }
                                    Th("From")
                                    Th("To")
                                    Th("Subject")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for mail in mails {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: mail.id)
                                            ).html()
                                        }
                                        Td(mail.mailFrom).data("label", "From")
                                        Td(mail.mailTo).data("label", "To")
                                        Td(mail.subject)
                                            .data("label", "Subject")
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
                                                            "/admin/contact/forms/\(id)/emails/remove/?selectedIds[]=\(mail.id)",
                                                        className: "delete",
                                                        permission:
                                                            "contact:forms:update"
                                                    ),
                                                ],
                                                permissions: [
                                                    "contact:forms:update"
                                                ]
                                            )
                                        ).html()
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canRemove) { $0.class("select-table") }
                    ).html()
                ).html()
            }
        }
        .class("cms-section")
    }
}
