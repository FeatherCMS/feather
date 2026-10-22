import FeatherWebAdmin
import HTML
import Hummingbird
import RedirectModule
import SGML
import WebBuilders
import WebComponents

struct RedirectRuleTableContent: Component {
    let state: RedirectRuleTable.State

    private var searchValue: String { state.search ?? "" }

    private var hasActiveQuery: Bool {
        !searchValue.isEmpty || !(state.statusCode?.isEmpty ?? true)
    }

    private var returnTo: String {
        AdminLocation.url(
            path: state.routes.list.path,
            page: state.pageState.page,
            search: state.search,
            queryItems: state.statusCode.map { [("statusCode", $0)] } ?? []
        )
    }
    func html(context: inout BuilderContext) -> Div {
        let canDelete = state.permissions.allows(
            Rule.Permissions.delete
        )

        return context.build(
            AdminList(
                table: {
                    if state.pageState.isPageOutOfRange {
                        context.build(
                            AdminListInvalidPageState(
                                pageState: state.pageState,
                                path: state.routes.list.path
                            )
                        )
                    }
                    else if state.rules.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No redirect rules match your search or filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset filters",
                                                href: state.routes.list.path,
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
                                    message: "No redirect rules yet.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        if state.permissions.allows(
                                            Rule.Permissions.create
                                        ) {
                                            context.build(
                                                AdminButton(
                                                    "Add rule",
                                                    href: state.routes.add.path
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
                            AdminListSelectionForm(
                                state: .init(
                                    action: AdminLocation.remove(
                                        path: state.routes.remove.path,
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
                                    AdminListShell(
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
                                                            AdminListSelectAllCheckbox()
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
                                                                .permissions,
                                                            routes: state.routes
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
                        AdminListSearch(
                            state: .init(
                                action: state.routes.list.path,
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
                        Rule.Permissions.create
                    ) {
                        context.build(
                            AdminListToolbar {
                                context.build(
                                    AdminButton(
                                        "Add rule",
                                        href: state.routes.add.path
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
                                path: state.routes.list.path,
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
