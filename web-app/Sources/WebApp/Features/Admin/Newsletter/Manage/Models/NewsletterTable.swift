import HTML
import SGML
import WebStandards

struct NewsletterTable: Component {
    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let items: [AdminManageNewsletterItem]
        let search: String
        let permissions: Set<String>
        let isPicker: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1(state.isPicker ? "Select newsletter campaign" : "Campaigns")
            if state.isAdded { P("Campaign added successfully.") }
            if state.isEdited { P("Campaign edited successfully.") }
            if state.isRemoved { P("Campaign removed successfully.") }
            Div {
                AdminNavigationButton(
                    "Add campaign",
                    href: "/admin/newsletters/add/"
                )
            }
            .class("button-row")
            Br()
            Br()
            ListTableSearchForm(
                state: .init(
                    action: "/admin/newsletters/",
                    placeholder: "Quick search campaigns",
                    search: state.search
                )
            )
            if state.items.isEmpty {
                P(
                    state.search.isEmpty
                        ? "No campaigns yet."
                        : "No campaigns match your search."
                )
            }
            else {
                let canRemove = state.permissions.contains(
                    "newsletter:campaigns:delete"
                )
                ListTableBulkRemoveForm(
                    state: .init(
                        action: "/admin/newsletters/bulk-remove/",
                        page: 1,
                        search: state.search,
                        canRemove: canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        ListTableSelectAllCheckbox()
                                    }
                                    Th("Name")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in state.items {
                                    Tr {
                                        if canRemove {
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
                                                            "newsletter:campaigns:read",
                                                        copyText:
                                                            "@NewsletterCampaign(id: \(item.id))"
                                                    ),
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/newsletters/\(item.id)/details/",
                                                        className: "edit",
                                                        permission:
                                                            "newsletter:campaigns:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/newsletters/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "newsletter:campaigns:delete"
                                                    ),
                                                ],
                                                permissions: [
                                                    "newsletter:campaigns:read",
                                                    "newsletter:campaigns:update",
                                                    "newsletter:campaigns:delete",
                                                ]
                                            )
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canRemove) { $0.class("bulk-select-table") }
                    )
                )
            }
        }
        .class("cms-section")
    }
}
