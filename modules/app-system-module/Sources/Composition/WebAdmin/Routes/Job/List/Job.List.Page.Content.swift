import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemModule
import WebBuilders
import WebComponents

extension Job.List.Page {
    struct Content: Component {
    let jobs: [Components.Schemas.SystemJobQueryItemSchema]
    let permissions: AdminListActions
    let pageState: AdminListPageState
    let search: String?
    let status: Int?
    let routes: Job.Router.Routes

    private var searchValue: String {
        search ?? ""
    }

    func html(context: inout BuilderContext) -> Div {
        let hasActiveQuery = !(search?.isEmpty ?? true) || status != nil

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
                    else if jobs.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                AdminListNoResultsState(
                                    message:
                                        "No worker jobs match your filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            AdminButton(
                                                "Reset filters",
                                                href: routes.list.path,
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
                                    message: "No worker jobs yet.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                    }
                    else {
                        context.build(
                            AdminListShell(
                                layout: .init(
                                    name: "system-jobs",
                                    columns: [
                                        .fraction(1),
                                        .fraction(2),
                                        .fixed(140),
                                        .actions,
                                    ]
                                ),
                                table: Table {
                                    Thead {
                                        Tr {
                                            Th("Job")
                                            Th("Parameters")
                                            Th("Status")
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for job in jobs {
                                            context.build(
                                                Job.List.Row(
                                                    job: job,
                                                    permissions: permissions,
                                                    routes: routes
                                                )
                                            )
                                        }
                                    }
                                }
                                .class("cms-table", "action-table")
                            )
                        )
                    }
                },
                search: {
                    context.build(
                        AdminListSearch(
                            state: .init(
                                action: routes.list.path,
                                placeholder: "Quick search worker jobs",
                                search: searchValue
                            ),
                            additionalFields: {
                                Select {
                                    Option("All statuses")
                                        .value("")
                                        .if(status == nil) { $0.selected() }
                                    for option in Job.Status.options {
                                        Option(option.label)
                                            .value(String(option.value))
                                            .if(status == option.value) {
                                                $0.selected()
                                            }
                                    }
                                }
                                .name("status")
                                .ariaLabel("Filter by status")
                                .onChange("this.form.requestSubmit()")
                            }
                        )
                    )
                },
                pagination: {
                    context.build(
                        AdminListPagination(
                            state: .init(
                                path: routes.list.path,
                                pageState: pageState,
                                search: searchValue,
                                queryItems: status.map {
                                    [.init(name: "status", value: String($0))]
                                } ?? []
                            )
                        )
                    )
                }
            )
        )
    }
    }
}
