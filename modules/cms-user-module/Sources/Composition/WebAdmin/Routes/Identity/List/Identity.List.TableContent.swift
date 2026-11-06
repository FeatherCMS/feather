import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import UserAdminAPI
import UserModule
import WebBuilders
import WebComponents

extension Identity.List {
    struct TableContent: WebComponents.Component {
        let routes: Identity.Router.Routes
        let permissions: AdminListActions
        let identities: [Components.Schemas.UserIdentityQueryItemSchema]
        let pageState: AdminListPageState
        let search: String?
        let role: String?

        func html(context: inout BuilderContext) -> Div {
            let hasActiveQuery =
                !(search?.isEmpty ?? true) || !(role?.isEmpty ?? true)

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
                        else if identities.isEmpty {
                            if hasActiveQuery {
                                context.build(
                                    AdminListNoResultsState(
                                        message:
                                            "No user identities match your search or filters.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            context.build(
                                                AdminButton(
                                                    "Reset filters",
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
                                        message: "No user identities yet.",
                                        icon: FeatherIcons.inbox(),
                                        action: {
                                            if permissions.allows(
                                                Identity.Permissions.create
                                            ) {
                                                context.build(
                                                    AdminButton(
                                                        "Add new",
                                                        href: routes.add.path
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
                                Identity.Permissions.delete
                            )
                            context.build(
                                AdminListSelectionForm(
                                    state: .init(
                                        action: routes.remove.path
                                            .description,
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
                                                name: "user-identities",
                                                columns: [
                                                    .fixed(260),
                                                    .fixed(220),
                                                    .fixed(120),
                                                    .fraction(1),
                                                    .actions,
                                                ],
                                                minimumWidth: 1000
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
                                                            Th("ID")
                                                            Th("Name")
                                                            Th("Status")
                                                            Th("Roles")
                                                            Th("Actions")
                                                        }
                                                    }
                                                    Tbody {
                                                        for identity
                                                            in identities
                                                        {
                                                            context.build(
                                                                Identity.List
                                                                    .Row(
                                                                        routes:
                                                                            routes,
                                                                        identity:
                                                                            identity,
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
                                    placeholder: "Quick search user identities",
                                    search: search ?? ""
                                )
                            )
                        )
                    },
                    toolbar: {
                        if permissions.allows(
                            Identity.Permissions.create
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
