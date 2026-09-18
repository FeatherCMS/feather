import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import SystemAdminAPI
import SystemContracts
import WebBuilders
import WebComponents

struct SystemJobTableContent: Component {
    let jobs: [Components.Schemas.SystemJobSchema]
    let permissions: NewAdminListActions
    let pageState: NewAdminListPageState
    let search: String?
    let status: Int?

    private var searchValue: String {
        search ?? ""
    }

    func html(context: inout BuilderContext) -> Div {
        let hasActiveQuery = !(search?.isEmpty ?? true) || status != nil

        return context.build(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.build(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemJobRoutes.list.description
                            )
                        )
                    }
                    else if jobs.isEmpty {
                        if hasActiveQuery {
                            context.build(
                                NewAdminListNoResultsState(
                                    message:
                                        "No worker jobs match your filters.",
                                    icon: FeatherIcons.inbox(),
                                    action: {
                                        context.build(
                                            NewAdminButton(
                                                "Reset filters",
                                                href: SystemJobRoutes.list
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
                                    message: "No worker jobs yet.",
                                    icon: FeatherIcons.inbox()
                                )
                            )
                        }
                    }
                    else {
                        context.build(
                            NewAdminListShell(
                                layout: .init(
                                    name: "system-jobs",
                                    columns: [
                                        .fraction(1),
                                        .fraction(2),
                                        .fixed(140),
                                        .fixed(220),
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
                                                SystemJobRow(
                                                    job: job,
                                                    permissions: permissions
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
                        NewAdminListSearch(
                            state: .init(
                                action: SystemJobRoutes.list.description,
                                placeholder: "Quick search worker jobs",
                                search: searchValue
                            ),
                            additionalFields: {
                                Select {
                                    Option("All statuses")
                                        .value("")
                                        .if(status == nil) { $0.selected() }
                                    for option in SystemJobStatus.options {
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
                        NewAdminListPagination(
                            state: .init(
                                path: SystemJobRoutes.list.description,
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
