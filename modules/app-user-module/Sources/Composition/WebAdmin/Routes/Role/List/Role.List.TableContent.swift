import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Role.List {
    struct TableContent: WebComponents.Component {
        let routes: Role.Router.Routes
        let roles: [Components.Schemas.UserRoleQueryItemSchema]
        let permissions: AdminListActions
        let pageState: AdminListPageState
        let search: String?

        func html(context: inout BuilderContext) -> Div {
            let hasActiveQuery = !(search?.isEmpty ?? true)

            return context.build(
                AdminList(
                    table: {
                        if pageState.isPageOutOfRange {
                            context.build(
                                AdminListInvalidPageState(
                                    pageState: pageState,
                                    path: routes.list.path
                                )
                            )
                        }
                        else if roles.isEmpty {
                            if hasActiveQuery {
                                context.build(
                                    AdminListNoResultsState(
                                        message:
                                            "No user roles match your search.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.build(
                                                AdminButton(
                                                    "Reset search",
                                                    href: routes.list.path
                                                        .description,
                                                    style: .secondary
                                                )
                                            )
                                        }
                                    )
                                )
                            }
                            else {
                                context.build(
                                    AdminListEmptyState(
                                        message: "No user roles yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if permissions.allows(
                                                Role.Permissions
                                                    .create
                                            ) {
                                                context.build(
                                                    AdminButton(
                                                        "Add new",
                                                        href: routes.add.path
                                                            .description
                                                    )
                                                )
                                            }
                                        }
                                    )
                                )
                            }
                        }
                        else {
                            let canDelete = permissions.allows(
                                Role.Permissions.delete
                            )
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: routes.remove.path,
                                        pageState: pageState,
                                        search: search ?? "",
                                        button: .init(
                                            "Remove selected",
                                            style: .destructive
                                        ),
                                        isEnabled: canDelete
                                    ),
                                    table: context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "user-roles",
                                                columns: [
                                                    .fraction(1),
                                                    .fixed(220),
                                                ]
                                            ),
                                            hasSelection: canDelete,
                                            table:
                                                Table {
                                                    Thead {
                                                        Tr {
                                                            if canDelete {
                                                                context.build(
                                                                    AdminListSelectAllCheckbox()
                                                                )
                                                            }
                                                            Th("Name")
                                                            Th("Actions")
                                                        }
                                                    }
                                                    Tbody {
                                                        for role in roles {
                                                            context.build(
                                                                Row(
                                                                    routes:
                                                                        routes,
                                                                    role: role,
                                                                    permissions:
                                                                        permissions
                                                                )
                                                            )
                                                        }
                                                    }
                                                }
                                                .class(
                                                    "cms-table",
                                                    "action-table"
                                                )
                                                .if(canDelete) {
                                                    $0.class("select-table")
                                                }
                                        )
                                    )
                                )
                            )
                        }
                    },
                    search: {
                        context.build(
                            AdminListSearch(
                                state: .init(
                                    action: routes.list.path,
                                    placeholder: "Quick search user roles",
                                    search: search ?? ""
                                )
                            )
                        )
                    },
                    toolbar: {
                        if permissions.allows(
                            Role.Permissions.create
                        ) {
                            context.build(
                                AdminListToolbar {
                                    context.build(
                                        AdminButton(
                                            "Add new",
                                            href: routes.add.path
                                        )
                                    )
                                }
                            )
                        }
                    },
                    pagination: {
                        context.build(
                            AdminListPagination(
                                state: .init(
                                    path: routes.list.path,
                                    pageState: pageState,
                                    search: search ?? ""
                                )
                            )
                        )
                    }
                )
            )
        }
    }
}
