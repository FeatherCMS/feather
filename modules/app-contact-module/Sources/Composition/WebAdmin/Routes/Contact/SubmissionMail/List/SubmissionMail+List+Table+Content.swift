import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension SubmissionMail.List.Table {
    struct Content: Component {
        let id: String
        let mails: [ContactForm.Email]
        let permissions: AdminListActions
        let routes: Contact.Router.Routes

        func html(context: inout BuilderContext) -> Div {
            let pageState = AdminListPageState(
                page: 1,
                pageSize: max(mails.count, 1),
                total: mails.count
            )
            return context.build(
                AdminList(
                    table: {
                        if mails.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: "No email definitions yet.",
                                    icon: FeatherIcons.mail(),
                                    action: {
                                        if permissions.allows(
                                            SubmissionMail.Permissions.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add email",
                                                    href:
                                                        routes.formEmailAddPath(
                                                            id
                                                        )
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                        else {
                            let canDelete = permissions.allows(
                                SubmissionMail.Permissions.delete
                            )
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: routes.formEmailRemovePath(id),
                                        pageState: pageState,
                                        search: "",
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: canDelete
                                    ),
                                    table: context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "contact-form-emails",
                                                columns: [
                                                    .fraction(1), .fraction(1),
                                                    .fraction(1), .fixed(220),
                                                ]
                                            ),
                                            hasSelection: canDelete,
                                            table: Table {
                                                Thead {
                                                    Tr {
                                                        if canDelete {
                                                            context.build(
                                                                AdminListSelectAllCheckbox()
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
                                                            if canDelete {
                                                                context.build(
                                                                    AdminListRowCheckbox(
                                                                        id: mail
                                                                            .id
                                                                    )
                                                                )
                                                            }
                                                            Td(mail.mailFrom)
                                                                .data(
                                                                    "label",
                                                                    "From"
                                                                )
                                                            Td(mail.mailTo)
                                                                .data(
                                                                    "label",
                                                                    "To"
                                                                )
                                                            Td(mail.subject)
                                                                .data(
                                                                    "label",
                                                                    "Subject"
                                                                )
                                                            context.build(
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                routes
                                                                                .formEmailEditPath(
                                                                                    formKey:
                                                                                        id,
                                                                                    mailId:
                                                                                        mail
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                SubmissionMail
                                                                                .Permissions
                                                                                .update
                                                                        )
                                                                    ],
                                                                    permissions:
                                                                        permissions
                                                                )
                                                            )
                                                        }
                                                    }
                                                }
                                            }
                                            .class("cms-table", "action-table")
                                            .if(canDelete) {
                                                $0.class("select-table")
                                            }
                                        )
                                    )
                                )
                            )
                        }
                    },
                    toolbar: {
                        if permissions.allows(SubmissionMail.Permissions.create)
                        {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add email",
                                            href: routes.formEmailAddPath(id)
                                        )
                                    )
                                }
                            )
                        }
                    }
                )
            )
        }
    }
}
