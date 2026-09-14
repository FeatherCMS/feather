import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct ContactFormEmails: Component {
    let id: String
    let mails: [AdminContactFormEmail]
    let canRemove: Bool
    let breadcrumb: AdminBreadcrumb.State
    let error: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: id, active: .emails))
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Contact form emails")
            if let error { P(error).class("error") }
            Div {
                context.render(
                    AdminNavigationButton(
                        "Add email",
                        href: "/admin/contact/forms/\(id)/emails/add/"
                    )
                )
            }
            .class("button-row")
            Br()
            Br()
            if mails.isEmpty {
                P("No emails configured yet.")
            }
            else {
                context.render(
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/contact/forms/\(id)/emails/remove/",
                            page: 1,
                            search: "",
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: context.render(
                            ListTableShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            if canRemove {
                                                context.render(
                                                    ListTableSelectAllCheckbox()
                                                )
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
                                                    context.render(
                                                        ListTableRowSelectCheckbox(
                                                            state: .init(
                                                                id: mail.id
                                                            )
                                                        )
                                                    )
                                                }
                                                Td(mail.mailFrom)
                                                    .data("label", "From")
                                                Td(mail.mailTo)
                                                    .data("label", "To")
                                                Td(mail.subject)
                                                    .data("label", "Subject")
                                                context.render(
                                                    ListTableRowActions(
                                                        state: .init(
                                                            label: "Actions",
                                                            actions: [
                                                                .init(
                                                                    title:
                                                                        "Edit",
                                                                    href:
                                                                        "/admin/contact/forms/\(id)/emails/\(mail.id)/edit/",
                                                                    className:
                                                                        "edit",
                                                                    permission:
                                                                        "contact:forms:update"
                                                                ),
                                                                .init(
                                                                    title:
                                                                        "Remove",
                                                                    href:
                                                                        "/admin/contact/forms/\(id)/emails/remove/?selectedIds[]=\(mail.id)",
                                                                    className:
                                                                        "delete",
                                                                    permission:
                                                                        "contact:forms:update"
                                                                ),
                                                            ],
                                                            permissions: [
                                                                "contact:forms:update"
                                                            ]
                                                        )
                                                    )
                                                )
                                            }
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                                .if(canRemove) { $0.class("select-table") }
                            )
                        )
                    )
                )
            }
        }
        .class("cms-section")
    }
}
