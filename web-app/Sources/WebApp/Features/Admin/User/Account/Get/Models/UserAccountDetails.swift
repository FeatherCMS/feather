import HTML
import SGML
import WebStandards

struct UserAccountDetails: Component {
    struct State {
        let account: AdminGetUserAccountModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isSessionRemoved: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: state.breadcrumb)
            H1("User account details")
            AdminDetailsField(label: "ID", value: state.account.id)
            AdminDetailsField(label: "Email", value: state.account.email)
            if state.account.roleNames.isEmpty {
                AdminDetailsField(label: "Roles", value: "No roles assigned")
            }
            else {
                Div {
                    P("Roles")
                        .class("admin-details-field__label")
                    Ul {
                        for roleName in state.account.roleNames {
                            Li(roleName)
                        }
                    }
                }
                .class("admin-details-field")
            }

            Div {
                AdminNavigationButton(
                    "Edit account",
                    href: "/admin/user/accounts/\(state.account.id)/edit/"
                )
                AdminNavigationButton(
                    "Remove account",
                    href: "/admin/user/accounts/\(state.account.id)/remove/",
                    classes: ["danger"]
                )
            }
            .class(
                "button-row",
                "user-account-details-actions",
                "admin-detail-actions"
            )

            H2("Session")
            if state.isSessionRemoved {
                P("Session removed successfully.")
            }
            if state.account.sessions.isEmpty {
                P("No auth sessions found for this account.")
            }
            else {
                let canRemove = state.permissions.contains(
                    "auth:sessions:delete"
                )
                ListTableBulkRemoveForm(
                    state: .init(
                        action:
                            "/admin/user/accounts/\(state.account.id)/sessions/bulk-remove/",
                        page: 1,
                        search: "",
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
                                    Th("Session ID")
                                    Th("Persistent")
                                    Th("Expires")
                                    Th("Created")
                                    Th("Updated")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for session in state.account.sessions {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: session.id)
                                            )
                                        }
                                        Td(session.id)
                                        Td(session.isPersistent ? "Yes" : "No")
                                        Td(
                                            DateFormatting.formatUnixTimestamp(
                                                session.expiresAt
                                            )
                                        )
                                        Td(
                                            DateFormatting.formatUnixTimestamp(
                                                session.createdAt
                                            )
                                        )
                                        Td(
                                            DateFormatting.formatUnixTimestamp(
                                                session.updatedAt
                                            )
                                        )
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/user/accounts/\(state.account.id)/sessions/\(session.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "auth:sessions:delete"
                                                    )
                                                ],
                                                permissions: state.permissions
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
