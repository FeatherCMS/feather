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
    let pageState: NewAdminListPageState
    let search: String
    let permissions: NewAdminListActions
    let isPicker: Bool

    func html(context: inout RenderContext) -> Div {
        let returnTo = NewAdminLocation.url(
            path: ContactAdminRoutes.forms.description,
            page: pageState.page,
            search: search
        )
        return context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: ContactAdminRoutes.forms.description
                            )
                        )
                    }
                    else if items.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: search.isEmpty
                                    ? "No contact forms yet."
                                    : "No contact forms match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if search.isEmpty {
                                        if permissions.allows(
                                            ContactPermissions.Forms.create
                                        ) {
                                            context.render(
                                                NewAdminButton(
                                                    "Add form",
                                                    href: ContactAdminRoutes
                                                        .formAdd.description
                                                )
                                            )
                                        }
                                    }
                                    else {
                                        context.render(
                                            NewAdminButton(
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
                        context.render(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
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
                                table: context.render(
                                    NewAdminListShell(
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
                                                        context.render(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("ID")
                                                    Th("Name")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for item in items {
                                                    Tr {
                                                        if canDelete {
                                                            context.render(
                                                                NewAdminListRowCheckbox(
                                                                    id: item.id
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
                                                                    item.id
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
                                                        context.render(
                                                            NewAdminListRowActions(
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
                                                                                        .id
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
                                                                                        .id
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
                                                                    .init(
                                                                        "Remove",
                                                                        href:
                                                                            NewAdminLocation
                                                                            .remove(
                                                                                path:
                                                                                    ContactAdminRoutes
                                                                                    .formRemove
                                                                                    .description,
                                                                                ids: [
                                                                                    item
                                                                                        .id
                                                                                ],
                                                                                returnTo:
                                                                                    returnTo
                                                                            ),
                                                                        style:
                                                                            .destructive,
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Forms
                                                                            .delete
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
                    context.render(
                        NewAdminListSearch(
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
                        context.render(
                            NewAdminListToolbar {
                                context.render(
                                    NewAdminButton(
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
                    context.render(
                        NewAdminListPagination(
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
                Span(item.id)
                if permissions.allows(ContactPermissions.Forms.read) {
                    Button {
                        FeatherIcons.clipboard()
                    }
                    .type(.button)
                    .ariaLabel("Copy contact form identifier \(item.id)")
                    .onClick(
                        "navigator.clipboard.writeText('@ContactForm(id: \(item.id))').then(()=>window.toast&&window.toast.success('Copied','Contact form identifier copied to clipboard'))"
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
        .data("label", "ID")
    }
}
