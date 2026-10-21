import ContactContracts
import FeatherWebAdmin
import FeatherModuleKit
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct ContactFieldsTableContent: Component {
    let fields: [AdminContactFieldRow]
    let pageState: AdminListPageState
    let search: String
    let permissions: AdminListActions

    private var emptyStateMessage: String {
        if formKey == FormFieldListFilter.unassigned {
            return search.isEmpty
                ? "No unassigned contact form fields."
                : "No unassigned fields match your search."
        }
        if formKey != nil {
            return search.isEmpty
                ? "This form has no assigned fields."
                : "No assigned fields match your search."
        }
        return search.isEmpty
            ? "No contact form fields yet."
            : "No contact form fields match your search."
    }

    func html(context: inout BuilderContext) -> Div {
        let returnTo = AdminLocation.url(
            path: ContactAdminRoutes.fields.description,
            page: pageState.page,
            search: search,
            queryItems: formKey.map { [("form", $0)] } ?? []
        )
        return context.build(
            AdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: pageState,
                                path: ContactAdminRoutes.fields.description
                            )
                        )
                    }
                    else if fields.isEmpty {
                        context.build(
                            AdminListEmptyState(
                                message: search.isEmpty
                                    ? "No contact form fields yet."
                                    : "No contact form fields match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if search.isEmpty && formKey == nil {
                                        if permissions.allows(
                                            ContactPermissions.Fields.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add field",
                                                    href: ContactAdminRoutes
                                                        .fieldAdd.description
                                                )
                                            )
                                        }
                                    }
                                    else if !search.isEmpty || formKey != nil {
                                        context.build(
                                            AdminButton(
                                                "Reset search",
                                                href: ContactAdminRoutes.fields
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
                            ContactPermissions.Fields.delete
                        )
                        context.build(
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
                                        path: ContactAdminRoutes.fieldRemove
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
                                            name: "contact-fields",
                                            columns: [
                                                .fraction(1), .fraction(1),
                                                .fraction(1), .fixed(110),
                                                .fixed(220),
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
                                                    Th("Label")
                                                    Th("Type")
                                                    Th("Required")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for field in fields {
                                                    Tr {
                                                        if canDelete {
                                                            context.build(
                                                                AdminListRowCheckbox(
                                                                    id: field.id
                                                                )
                                                            )
                                                        }
                                                        Td(field.key)
                                                            .data(
                                                                "label",
                                                                "Key"
                                                            )
                                                        Td(field.label)
                                                            .data(
                                                                "label",
                                                                "Label"
                                                            )
                                                        Td {
                                                            context.build(
                                                                typeChip(
                                                                    field.type
                                                                )
                                                            )
                                                        }
                                                        .data("label", "Type")
                                                        Td(
                                                            field.isRequired
                                                                ? "Yes" : "No"
                                                        )
                                                        .data(
                                                            "label",
                                                            "Required"
                                                        )
                                                        context.build(
                                                            AdminListRowActions(
                                                                label:
                                                                    "Actions",
                                                                actions: [
                                                                    .init(
                                                                        "Edit",
                                                                        href:
                                                                            ContactAdminRoutes
                                                                            .fields
                                                                            .appendingPath(
                                                                                RouterPath(
                                                                                    field
                                                                                        .id
                                                                                )
                                                                            )
                                                                            .appendingPath(
                                                                                RouterPath(
                                                                                    "edit"
                                                                                )
                                                                            )
                                                                            .description,
                                                                        style:
                                                                            .ghost(
                                                                                .secondary
                                                                            ),
                                                                        permission:
                                                                            ContactPermissions
                                                                            .Fields
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
                                action: ContactAdminRoutes.fields.description,
                                placeholder: "Quick search contact fields",
                                search: search,
                                resetPath: NewAdminLocation.url(
                                    path: ContactAdminRoutes.fields.description,
                                    queryItems: formKey.map { [("form", $0)] }
                                        ?? []
                                )
                            ),
                            additionalFields: {
                                Div {
                                    Select {
                                        Option("All forms").value("")
                                            .if(formKey == nil) {
                                                $0.selected()
                                            }
                                        Option("No form assigned")
                                            .value(FormFieldListFilter.unassigned)
                                            .if(
                                                formKey == FormFieldListFilter
                                                    .unassigned
                                            ) {
                                                $0.selected()
                                            }
                                        for form in forms {
                                            Option(form.name)
                                                .value(form.key)
                                                .if(form.key == formKey) {
                                                    $0.selected()
                                                }
                                            }
                                        }
                                    .name("form")
                                    .ariaLabel("Filter fields by form")
                                    .onChange("this.form.requestSubmit()")
                                }
                                .class("table-search-filter")
                            }
                        )
                    )
                },
                toolbar: {
                    if permissions.allows(ContactPermissions.Fields.create) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add field",
                                        href: ContactAdminRoutes.fieldAdd
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
                                path: ContactAdminRoutes.fields.description,
                                pageState: pageState,
                                search: search,
                                queryItems: formKey.map {
                                    [.init(name: "form", value: $0)]
                                } ?? []
                            )
                        )
                    )
                }
            )
        )
    }

    private func typeChip(_ type: String) -> AdminChip {
        let color: AdminChip.ColorName
        switch type.lowercased() {
        case "textarea": color = .purple
        case "select": color = .green
        case "radio": color = .orange
        case "toggle": color = .yellow
        case "hidden": color = .gray
        default: color = .blue
        }
        return .init(label: type.capitalized, color: color)
    }
}
