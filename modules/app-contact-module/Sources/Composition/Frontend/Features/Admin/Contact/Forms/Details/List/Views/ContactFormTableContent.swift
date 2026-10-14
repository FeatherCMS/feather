import ContactContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFormTableContent: Component {
    let items: [AdminContactFormDetailsItem]
    let pageState: AdminListPageState
    let search: String
    let permissions: AdminListActions
    let isPicker: Bool

    func html(context: inout BuilderContext) -> Div {
        let returnTo = AdminLocation.url(
            path: ContactAdminRoutes.forms.description,
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
                                path: ContactAdminRoutes.forms.description
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
                                            ContactPermissions.Forms.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add form",
                                                    href: ContactAdminRoutes
                                                        .formAdd.description
                                                )
                                            )
                                        }
                                    }
                                    else {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: ContactAdminRoutes.forms
                                                    .description,
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
                            ContactPermissions.Forms.delete
                        )
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
                                        path: ContactAdminRoutes.formRemove
                                            .description,
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
                                                .fixed(250),
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
                                                                    id: item.key
                                                                )
                                                            )
                                                        }
                                                        identifierCell(
                                                            item: item
                                                        )
                                                        if isPicker {
                                                            Td {
                                                                Button(
                                                                    item.name
                                                                )
                                                                .type(.button)
                                                                .data(
                                                                    "mce-picker-item",
                                                                    item.key
                                                                )
                                                                .data(
                                                                    "mce-picker-label",
                                                                    item.name
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
                                                                            ContactAdminRoutes
                                                                            .formDetails(
                                                                                RouterPath(
                                                                                    item
                                                                                        .key
                                                                                )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .primary
                                                                            ),
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Forms
                                                                            .read
                                                                    ),
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            ContactAdminRoutes
                                                                            .formEdit(
                                                                                RouterPath(
                                                                                    item
                                                                                        .key
                                                                                )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .secondary
                                                                            ),
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Forms
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
                                action: ContactAdminRoutes.forms.description,
                                placeholder: "Quick search contact forms",
                                search: search
                            )
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(ContactPermissions.Forms.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add form",
                                        href: ContactAdminRoutes.formAdd
                                            .description
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
                                path: ContactAdminRoutes.forms.description,
                                pageState: pageState,
                                search: search
                            )
                        )
                    )
                }
            )
        )
    }

    private func identifierCell(item: AdminContactFormDetailsItem) -> Td {
        Td {
            Span {
                Span(item.key)
                if permissions.allows(ContactPermissions.Forms.read) {
                    Button {
                        FeatherIcons.clipboard()
                    }
                    .type(.button)
                    .ariaLabel("Copy contact form key \(item.key)")
                    .onClick(
                        "navigator.clipboard.writeText('@ContactForm(key: \(item.key))').then(()=>window.toast&&window.toast.success('Copied','Contact form key copied to clipboard'))"
                    )
                    .style(
                        "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;padding:0;border:0;background:transparent;color:var(--cms-link);cursor:pointer;"
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
