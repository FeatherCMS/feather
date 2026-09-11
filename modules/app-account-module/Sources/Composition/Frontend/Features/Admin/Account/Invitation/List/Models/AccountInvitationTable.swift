import AccountAdminAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebComponents
import WebBuilders

struct AccountInvitationTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let invitations: [Components.Schemas.AccountInvitationListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                context.render(AdminBreadcrumb(state: state.breadcrumb))
                H1("User invitations")

                if state.isAdded {
                    P("User invitation added successfully.")
                }
                if state.isEdited {
                    P("User invitation edited successfully.")
                }
                if state.isRemoved {
                    P("User invitation removed successfully.")
                }
                if state.canAdd {
                    Div {
                        context.render(AdminNavigationButton(
                            "Add invitation",
                            href: "/admin/account/invitations/add/"
                        ))
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                context.render(ListTableSearchForm(
                    state: .init(
                        action: "/admin/account/invitations/",
                        placeholder: "Quick search invitations",
                        search: state.search
                    )
                ))

                if state.invitations.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1")
                                .href("/admin/account/invitations/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/account/invitations/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No user invitations yet."
                                : "No invitations match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "account:invitations:delete"
                    )
                    context.render(ListTableRemoveForm(
                        state: .init(
                            action: "/admin/account/invitations/remove/",
                            page: state.page,
                            search: state.search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected"
                        ),
                        table: context.render(ListTableShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canRemove {
                                            context.render(ListTableSelectAllCheckbox())
                                        }
                                        Th("Email")
                                            .columnWidth(percent: 62)
                                        Th("Expires At")
                                            .columnWidth(percent: 28)
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for invitation in state.invitations {
                                        Tr {
                                            if canRemove {
                                                context.render(ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: invitation.id
                                                    )
                                                ))
                                            }
                                            Td(invitation.email)
                                                .data(
                                                    "label",
                                                    "Email"
                                                )
                                                .columnWidth(percent: 62)
                                            Td(
                                                DateFormatting
                                                    .formatUnixTimestamp(
                                                        invitation.expiresAt
                                                    )
                                            )
                                            .data(
                                                "label",
                                                "Expires At"
                                            )
                                            .columnWidth(percent: 28)
                                            context.render(ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/account/invitations/\(invitation.id)/",
                                                            className: nil,
                                                            permission:
                                                                "account:invitations:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/account/invitations/\(invitation.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "account:invitations:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/account/invitations/\(invitation.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "account:invitations:delete"
                                                        ),
                                                    ],
                                                    permissions: state
                                                        .permissions
                                                )
                                            ))
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ))
                    ))
                    context.render(ListTablePagination(
                        state: .init(
                            path: "/admin/account/invitations/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    ))
                }
            }
        }
        .class("cms-section")
    }
}
