import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct RedirectRuleTable: Component {

    private static let statusOptions = [
        ("", "All statuses"),
        ("301", "301 Moved Permanently"),
        ("302", "302 Found"),
        ("307", "307 Temporary Redirect"),
        ("308", "308 Permanent Redirect"),
    ]

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let rules: [Components.Schemas.RedirectRuleListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let statusCode: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Redirect rules")

                if state.isAdded {
                    P("Redirect rule added successfully.")
                }
                if state.isEdited {
                    P("Redirect rule edited successfully.")
                }
                if state.isRemoved {
                    P("Redirect rule removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add rule",
                            href: "/admin/redirect/rules/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                Form {
                    Div {
                        Input()
                            .type(.search)
                            .name("search")
                            .value(state.search)
                            .placeholder("Quick search redirect rules")
                        Select {
                            for option in Self.statusOptions {
                                if state.statusCode == option.0 {
                                    Option(option.1)
                                        .value(option.0)
                                        .selected()
                                }
                                else {
                                    Option(option.1)
                                        .value(option.0)
                                }
                            }
                        }
                        .name("statusCode")
                        Button("Search").type(.submit)
                        A("Reset")
                            .href("/admin/redirect/rules/")
                    }
                    .class("table-search-form", "redirect-rule-search-form")
                }
                .method(.get)
                .action("/admin/redirect/rules/")

                if state.rules.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/redirect/rules/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/redirect/rules/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No redirect rules yet."
                                : "No redirect rules match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "redirect:rules:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/redirect/rules/bulk-remove/",
                            page: state.page,
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
                                        Th("Source")
                                        Th("Destination")
                                        Th("Status")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for rule in state.rules {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: rule.id
                                                    )
                                                )
                                            }
                                            Td(rule.source)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Source"
                                                )
                                            Td(rule.destination)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Destination"
                                                )
                                            Td("\(rule.statusCode)")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Status"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/redirect/rules/\(rule.id)/",
                                                            className: nil,
                                                            permission:
                                                                "redirect:rules:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/redirect/rules/\(rule.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "redirect:rules:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/redirect/rules/\(rule.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "redirect:rules:delete"
                                                        ),
                                                    ],
                                                    permissions: state
                                                        .permissions
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
                    ListTablePagination(
                        state: .init(
                            path: "/admin/redirect/rules/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search,
                            queryItems: [("statusCode", state.statusCode)]
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }
}
