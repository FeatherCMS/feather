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
import WebStandards

struct AuthEmailTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let links:
            [AuthAdminAPI.Components.Schemas.AuthIdentityEmailDetailSchema]
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

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("User emails")

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
                            label: "Emails",
                            href: "/admin/auth/emails/?userId=\(userID)",
                            isCurrent: true
                        ),
                    ])
                }

                if state.isAdded {
                    P("User email added successfully.")
                }
                if state.isEdited {
                    P("User email edited successfully.")
                }
                if state.isRemoved {
                    P("User email removed successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add email",
                            href: "/admin/auth/emails/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/auth/emails/",
                        placeholder: "Quick search emails",
                        search: state.search,
                        queryItems: state.userID.map { [("userId", $0)] } ?? []
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
                            A("page 1")
                                .href(
                                    "/admin/auth/emails/?page=1&userId=\(state.userID ?? "")"
                                )
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/auth/emails/?page=\(totalPages)&userId=\(state.userID ?? "")"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No user emails yet."
                                : "No emails match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "auth:emails:delete"
                    )
                    ListTableRemoveForm(
                        state: .init(
                            action: "/admin/auth/emails/remove/",
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
                                            ListTableSelectAllCheckbox()
                                        }
                                        Th("Identity ID")
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
                                            Td(link.identityId)
                                                .data("label", "Identity ID")
                                                .columnWidth(percent: 50)
                                            .data("label", "Expires At")
                                            .columnWidth(percent: 24)
                                            Td(link.isPrimary ? "Yes" : "No")
                                                .data("label", "Persistent")
                                                .columnWidth(percent: 10)
                                            ListTableRowActions(
                                                state: .init(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            title: "Details",
                                                            href:
                                                                "/admin/auth/emails/\(link.id)/",
                                                            className: nil,
                                                            permission:
                                                                "auth:emails:read"
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/auth/emails/\(link.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                "auth:emails:update"
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/auth/emails/\(link.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                "auth:emails:delete"
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
                            .if(canRemove) { $0.class("select-table") }
                        )
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/auth/emails/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search,
                            queryItems: state.userID.map { [("userId", $0)] }
                                ?? []
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }
}
