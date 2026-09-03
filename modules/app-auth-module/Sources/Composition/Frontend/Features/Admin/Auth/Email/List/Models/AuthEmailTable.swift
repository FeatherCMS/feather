import AuthAdminAPI
import AuthAppAPI
import AuthContracts
import CSS
import FeatherAdmin
import FeatherContracts
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
            [AuthAdminAPI.Components.Schemas.AuthEmailDetailSchema]
        let identityNames: [String: String]
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
                        AuthPermissions.Emails.delete.rawValue
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
                                        Th("User name")
                                            .columnWidth(percent: 30)
                                        Th("Email")
                                            .columnWidth(percent: 30)
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
                                            Td(
                                                state.identityNames[link.identityId]
                                                    ?? "Unknown user"
                                            )
                                                .data("label", "User name")
                                                .columnWidth(percent: 30)
                                            Td(link.email)
                                                .data("label", "Email")
                                                .columnWidth(percent: 30)
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
                                                                AuthPermissions
                                                                .Emails.read.rawValue
                                                        ),
                                                        .init(
                                                            title: "Edit",
                                                            href:
                                                                "/admin/auth/emails/\(link.id)/edit/",
                                                            className: "edit",
                                                            permission:
                                                                AuthPermissions
                                                                .Emails.update.rawValue
                                                        ),
                                                        .init(
                                                            title: "Remove",
                                                            href:
                                                                "/admin/auth/emails/\(link.id)/remove/",
                                                            className: "delete",
                                                            permission:
                                                                AuthPermissions
                                                                .Emails.delete.rawValue
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
