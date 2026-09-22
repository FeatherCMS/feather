import FeatherAdmin
import HTML
import Hummingbird
import RedirectContracts
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleTableContent: Component {
    let state: RedirectRuleTable.State

    private var searchValue: String { state.search ?? "" }

    private var hasActiveQuery: Bool {
        !searchValue.isEmpty || !(state.statusCode?.isEmpty ?? true)
    }

    private var returnTo: String {
        NewAdminLocation.url(
            path: RedirectRuleRoutes.list.description,
            page: state.pageState.page,
            search: state.search,
            queryItems: state.statusCode.map { [("statusCode", $0)] } ?? []
        )
    }

    func html(context: inout BuilderContext) -> Div {
        let canDelete = state.permissions.allows(
            RedirectPermissions.Rules.delete
        )

        return context.build(
            NewAdminList(
                table: {
                    if state.pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: state.pageState,
                                path: RedirectRuleRoutes.list.description
                            )
                        )
                    }
                    else if state.rules.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message:
                                        "No redirect rules match your search or filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            NewAdminButton(
                                                "Reset filters",
                                                href: RedirectRuleRoutes.list
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
                                NewAdminListEmptyState(
                                    message: "No redirect rules yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if state.permissions.allows(
                                            RedirectPermissions.Rules.create
                                        ) {
                                            context.build(
                                                NewAdminButton(
                                                    "Add rule",
                                                    href: RedirectRuleRoutes.add
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
                        context.build(
                            NewAdminListSelectionForm(
                                state: .init(
                                    action: NewAdminLocation.remove(
                                        path: RedirectRuleRoutes.remove
                                            .description,
                                        ids: [],
                                        returnTo: returnTo
                                    ),
                                    pageState: state.pageState,
                                    search: searchValue,
                                    button: .init(
                                        "Remove selected",
                                        style: .destructive
                                    ),
                                    isEnabled: canDelete
                                ),
                                table: context.build(
                                    NewAdminListShell(
                                        layout: .init(
                                            name: "redirect-rules",
                                            columns: [
                                                .fraction(1),
                                                .fraction(2),
                                                .fixed(190),
                                                .fixed(220),
                                            ],
                                            minimumWidth: 760
                                        ),
                                        hasSelection: canDelete,
                                        table: Table {
                                            Thead {
                                                Tr {
                                                    if canDelete {
                                                        context.build(
                                                            NewAdminListSelectAllCheckbox()
                                                        )
                                                    }
                                                    Th("Source")
                                                    Th("Destination")
                                                    Th("Status")
                                                    Th("Actions")
                                                }
                                            }
                                            Tbody {
                                                for rule in state.rules {
                                                    context.build(
                                                        RedirectRuleRow(
                                                            rule: rule,
                                                            returnTo: returnTo,
                                                            permissions: state
                                                                .permissions
                                                        )
                                                    )
                                                }
                                            }
                                        }
                                        .class("cms-table", "action-table")
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
                        NewAdminListSearch(
                            state: .init(
                                action: RedirectRuleRoutes.list.description,
                                placeholder: "Quick search redirect rules",
                                search: searchValue
                            ),
                            additionalFields: {
                                Select {
                                    Option("All statuses")
                                        .value("")
                                        .if(state.statusCode?.isEmpty ?? true) {
                                            $0.selected()
                                        }
                                    Option("301 Moved Permanently")
                                        .value("301")
                                        .if(state.statusCode == "301") {
                                            $0.selected()
                                        }
                                    Option("302 Found")
                                        .value("302")
                                        .if(state.statusCode == "302") {
                                            $0.selected()
                                        }
                                    Option("307 Temporary Redirect")
                                        .value("307")
                                        .if(state.statusCode == "307") {
                                            $0.selected()
                                        }
                                    Option("308 Permanent Redirect")
                                        .value("308")
                                        .if(state.statusCode == "308") {
                                            $0.selected()
                                        }
                                }
                                .name("statusCode")
                            }
                        )
                    )
                },
                toolbar: {
                    if state.permissions.allows(
                        RedirectPermissions.Rules.create
                    ) {
                        context.build(
                            NewAdminListToolbar {
                                context.build(
                                    NewAdminButton(
                                        "Add rule",
                                        href: RedirectRuleRoutes.add.description
                                    )
                                )
                            }
                        )
                    }
                },
                pagination: {
                    context.build(
                        NewAdminListPagination(
                            state: .init(
                                path: RedirectRuleRoutes.list.description,
                                pageState: state.pageState,
                                search: searchValue,
                                queryItems: state.statusCode.map {
                                    [.init(name: "statusCode", value: $0)]
                                } ?? []
                            )
                        )
                    )
                }
            )
        )
    }
}
