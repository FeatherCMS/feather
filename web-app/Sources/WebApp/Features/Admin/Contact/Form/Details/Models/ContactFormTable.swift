import HTML
import SGML
import WebStandards

struct ContactFormTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminContactFormDetailsItem]
        let search: String
        let canRemove: Bool
        let isPicker: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1(state.isPicker ? "Select contact form" : "Contact forms")
            if state.isAdded { P("Contact form added successfully.") }
            if state.isEdited { P("Contact form edited successfully.") }
            if state.isRemoved { P("Contact form removed successfully.") }
            Div {
                AdminNavigationButton(
                    "Add form",
                    href: "/admin/contact/forms/add/"
                )
            }
            .class("button-row")
            Br()
            Br()
            ListTableSearchForm(
                state: .init(
                    action: "/admin/contact/forms/",
                    placeholder: "Quick search contact forms",
                    search: state.search
                )
            )
            if state.items.isEmpty {
                P(
                    state.search.isEmpty
                        ? "No contact forms yet."
                        : "No contact forms match your search."
                )
            }
            else {
                ListTableBulkRemoveForm(
                    state: .init(
                        action: "/admin/contact/forms/remove/",
                        page: 1,
                        search: state.search,
                        canRemove: state.canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if state.canRemove {
                                        ListTableSelectAllCheckbox()
                                    }
                                    Th("Name")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in state.items {
                                    Tr {
                                        if state.canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: item.id)
                                            )
                                        }
                                        if state.isPicker {
                                            Td {
                                                Button(item.name)
                                                    .type(.button)
                                                    .data(
                                                        "mce-picker-item",
                                                        item.id
                                                    )
                                                    .data(
                                                        "mce-picker-label",
                                                        item.name
                                                    )
                                            }
                                            .data("label", "Name")
                                        }
                                        else {
                                            Td(item.name).data("label", "Name")
                                        }
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Copy",
                                                        className: nil,
                                                        permission:
                                                            "contact:forms:read",
                                                        copyText:
                                                            "@ContactForm(id: \(item.id))"
                                                    ),
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/contact/forms/\(item.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "contact:forms:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/contact/forms/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "contact:forms:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "contact:forms:read",
                                                    "contact:forms:update",
                                                    "contact:forms:delete",
                                                ]
                                            )
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(state.canRemove) { $0.class("bulk-select-table") }
                    )
                )
            }
        }
        .class("cms-section")
    }
}
