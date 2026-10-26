import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension ContactModule.Form.Search.Page {
    struct Content: Component {
        let items: [ContactModule.Form.Search.Model.Item]
        let pageState: AdminListPageState
        let search: String
        let permissions: AdminListActions
        let isPicker: Bool
        let routes: ContactModule.Form.Router.Routes

        func html(context: inout BuilderContext) -> Div {
            let returnTo = AdminLocation.url(
                path: routes.forms.path,
                page: pageState.page,
                search: search
            )
            return context.build(
                AdminList(
                    table: {
                        if pageState.isPageOutOfRange {
                            context.build(
                                AdminListInvalidPageState(
                                    pageState: pageState,
                                    path: routes.forms.path
                                )
                            )
                        }
                        else if items.isEmpty {
                            context.build(
                                AdminListEmptyState(
                                    message: search.isEmpty
                                        ? "No contact forms yet."
                                        : "No contact forms match your search.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if search.isEmpty {
                                            if permissions.allows(
                                                ContactModule.Form.Permissions
                                                    .create
                                            ) {
                                                context.build(
                                                    AdminButton(
                                                        "Add form",
                                                        href: routes.formAdd
                                                            .path
                                                    )
                                                )
                                            }
                                        }
                                        else {
                                            context.build(
                                                AdminButton(
                                                    "Reset search",
                                                    href: routes.forms.path,
                                                    style: .secondary
                                                )
                                            )
                                        }
                                    }
                                )
                            )
                        }
                        else {
                            let canDelete = permissions.allows(
                                ContactModule.Form.Permissions.delete
                            )
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: AdminLocation.remove(
                                            path: routes.formRemove.path,
                                            ids: [],
                                            returnTo: returnTo
                                        ),
                                        pageState: pageState,
                                        search: search,
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: canDelete
                                    ),
                                    table: context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "contact-forms",
                                                columns: [
                                                    .fraction(1), .fraction(2),
                                                    .actions,
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
                                                        Th("Key")
                                                        Th("Name")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for item in items {
                                                        Tr {
                                                            if canDelete {
                                                                context.build(
                                                                    AdminListRowCheckbox(
                                                                        id: item
                                                                            .key
                                                                    )
                                                                )
                                                            }
                                                            identifierCell(
                                                                item: item,
                                                                context:
                                                                    &context
                                                            )
                                                            if isPicker {
                                                                Td {
                                                                    Button(
                                                                        item
                                                                            .name
                                                                    )
                                                                    .type(
                                                                        .button
                                                                    )
                                                                    .data(
                                                                        "mce-picker-item",
                                                                        item.key
                                                                    )
                                                                    .data(
                                                                        "mce-picker-label",
                                                                        item
                                                                            .name
                                                                    )
                                                                    .class(
                                                                        "button",
                                                                        "ghost-primary"
                                                                    )
                                                                }
                                                                .data(
                                                                    "label",
                                                                    "Name"
                                                                )
                                                            }
                                                            else {
                                                                Td(item.name)
                                                                    .data(
                                                                        "label",
                                                                        "Name"
                                                                    )
                                                            }
                                                            context.build(
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "View",
                                                                            href:
                                                                                routes
                                                                                .formDetailsPath(
                                                                                    item
                                                                                        .key
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                Form
                                                                                .Permissions
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                routes
                                                                                .formEditPath(
                                                                                    item
                                                                                        .key
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                Form
                                                                                .Permissions
                                                                                .update
                                                                        ),
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
                    search: {
                        context.build(
                            AdminListSearch(
                                state: .init(
                                    action: routes.forms.path,
                                    placeholder: "Quick search contact forms",
                                    search: search
                                )
                            )
                        )
                    },
                    toolbar: {
                        if permissions.allows(
                            ContactModule.Form.Permissions.create
                        ) {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add form",
                                            href: routes.formAdd.path
                                        )
                                    )
                                }
                            )
                        }
                    },
                    pagination: {
                        context.build(
                            AdminListPagination(
                                state: .init(
                                    path: routes.forms.path,
                                    pageState: pageState,
                                    search: search
                                )
                            )
                        )
                    }
                )
            )
        }

        private func identifierCell(
            item: ContactModule.Form.Search.Model.Item,
            context: inout BuilderContext
        ) -> Td {
            Td {
                Span {
                    Span(item.key)
                    if permissions.allows(ContactModule.Form.Permissions.read) {
                        context.build(
                            AdminCopyButton(
                                value: "@ContactForm(key: \(item.key))",
                                label: "Copy contact form key \(item.key)",
                                copiedMessage:
                                    "Contact form key copied to clipboard"
                            )
                        )
                    }
                }
                .style(
                    "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;"
                )
            }
            .data("label", "Key")
        }
    }
}
