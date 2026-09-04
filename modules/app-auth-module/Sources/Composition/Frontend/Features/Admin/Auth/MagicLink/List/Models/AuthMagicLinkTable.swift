import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebComponents
import WebBuilders

struct AuthMagicLinkTable: Leaf {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let links: [AuthAdminAPI.Components.Schemas.AuthMagicLinkListItemSchema]
        let emailByAuthEmailId: [String: String]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let userID: String?
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).html()
                H1("User magic links")

                if let userID = state.userID {
                    AdminPillTabs(links: [
                        .init(
                            label: "Details",
                            href: "/admin/user/identities/\(userID)/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Profile",
                            href: "/admin/account/users/\(userID)/profile/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Settings",
                            href: "/admin/account/users/\(userID)/settings/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Sessions",
                            href: "/admin/user/identities/\(userID)/sessions/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Magic links",
                            href: "/admin/auth/magic-links/?userId=\(userID)",
                            isCurrent: true
                        ),
                    ]).html()
                }

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
                        ).html()
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/magic-links/",
                        placeholder: "Quick search magic links",
                        search: state.search,
                        queryItems: state.userID.map { [("userId", $0)] } ?? []
                    )
                ).html()

                if state.links.isEmpty {
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
                                    "/admin/auth/magic-links/?page=1&userId=\(state.userID ?? "")"
                                )
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/auth/magic-links/?page=\(totalPages)&userId=\(state.userID ?? "")"
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
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/auth/magic-links/remove/",
                            page: state.page,
                            search: state.search,
                            canRemove: canRemove,
                            buttonTitle: "Remove selected",
                            queryItems: state.userID.map { [("userId", $0)] }
                                ?? []
                        ),
                        table: ListTableShell(
                            table: Table {
                                Thead {
                                    Tr {
                                        if canRemove {
                                            ListTableSelectAllCheckbox().html()
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
                                                ).html()
                                            }
                                            Td(
                                                state.emailByAuthEmailId[
                                                    String(link.credentialId)
                                                ] ?? "Unknown email"
                                            )
                                            .data("label", "Email")
                                            .columnWidth(percent: 50)
                                            Td(
                                                DateFormatting
                                                    .formatUnixTimestamp(
                                                        link.expiresAt
                                                    )
                                            )
                                            .data("label", "Expires At")
                                            .columnWidth(percent: 24)
                                            Td(link.isPersistent ? "Yes" : "No")
                                                .data("label", "Persistent")
                                                .columnWidth(percent: 10)
                                            Td(link.isUsed ? "Yes" : "No")
                                                .data("label", "Used")
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
                                            ).html()
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("select-table") }
                        ).html()
                    ).html()
                    ListTablePagination(
                        state: .init(
                            path: "/admin/auth/magic-links/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search,
                            queryItems: state.userID.map { [("userId", $0)] }
                                ?? []
                        )
                    ).html()
                }
            }
        }
        .class("cms-section")
    }
}
