import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AuthMagicLinkTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let links: [Components.Schemas.UserMagicLinkListItemSchema]
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
                H1("User magic links")

                if state.isAdded {
                    P("User magic link added successfully.")
                }
                if state.isEdited {
                    P("User magic link edited successfully.")
                }
                if state.isRemoved {
                    P("User magic link removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add magic link",
                            href: "/admin/auth/magic-links/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/magic-links/",
                        placeholder: "Quick search magic links",
                        search: state.search
                    )
                )

                if state.links.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/auth/magic-links/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/auth/magic-links/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No user magic links yet."
                                : "No magic links match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "auth:magic-links:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/auth/magic-links/bulk-remove/",
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
                                        Th("Email")
                                            .columnWidth(percent: 50)
                                        Th("Expires At")
                                            .columnWidth(percent: 24)
                                        Th("Persistent")
                                            .columnWidth(percent: 10)
                                        Th("Used")
                                            .columnWidth(percent: 10)
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for link in state.links {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(id: link.id)
                                                )
                                            }
                                            Td(link.email)
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Email"
                                                )
                                                .columnWidth(percent: 50)
                                            Td(
                                                DateFormatting
                                                    .formatUnixTimestamp(
                                                        link.expiresAt
                                                    )
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Expires At"
                                            )
                                            .columnWidth(percent: 24)
                                            Td(link.isPersistent ? "Yes" : "No")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Persistent"
                                                )
                                                .columnWidth(percent: 10)
                                            Td(link.isUsed ? "Yes" : "No")
                                                .setAttribute(
                                                    name: "data-label",
                                                    value: "Used"
                                                )
                                                .columnWidth(percent: 10)
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/auth/magic-links/\(link.id)/",
                                                            className: nil,
                                                            permission:
                                                                "auth:magic-links:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/auth/magic-links/\(link.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "auth:magic-links:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/auth/magic-links/\(link.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "auth:magic-links:delete"
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
                            path: "/admin/auth/magic-links/",
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
