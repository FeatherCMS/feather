import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorLinkTable: Component {

    struct State {
        let menuId: String
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let items: [Components.Schemas.BlogAuthorLinkListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
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
                H1("Blog author links")

                if state.isAdded {
                    P("Blog author link added successfully.")
                }
                if state.isEdited {
                    P("Blog author link edited successfully.")
                }
                if state.isRemoved {
                    P("Blog author link removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add link",
                            href:
                                "/admin/blog/authors/\(state.menuId)/links/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/blog/authors/\(state.menuId)/links/",
                        placeholder: "Quick search blog author links",
                        search: state.search
                    )
                )

                if state.items.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1")
                                .href(
                                    "/admin/blog/authors/\(state.menuId)/links/?page=1"
                                )
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/blog/authors/\(state.menuId)/links/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No blog author links yet."
                                : "No blog author links match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "blog:author-links:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action:
                                "/admin/blog/authors/\(state.menuId)/links/bulk-remove/",
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
                                        Th("Label")
                                        Th("URL")
                                        Th("Priority")
                                        Th("Blank")
                                        Th("Permission")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for item in state.items {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: item.id
                                                    )
                                                )
                                            }
                                            Td(item.label)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Label"
                                                )
                                            Td(item.url)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "URL"
                                                )
                                            Td("\(item.priority)")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Priority"
                                                )
                                            Td(item.isBlank ? "Yes" : "No")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Blank"
                                                )
                                            Td(item.permission)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Permission"
                                                )
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/blog/authors/\(state.menuId)/links/\(item.id)/",
                                                            className: nil,
                                                            permission:
                                                                "blog:author-links:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/blog/authors/\(state.menuId)/links/\(item.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "blog:author-links:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/blog/authors/\(state.menuId)/links/\(item.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "blog:author-links:delete"
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
                            path: "/admin/blog/authors/\(state.menuId)/links/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }
}
