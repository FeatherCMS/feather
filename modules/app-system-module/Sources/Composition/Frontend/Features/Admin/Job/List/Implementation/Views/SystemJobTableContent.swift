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

    private var searchValue: String {
        search ?? ""
    }

    func html(context: inout RenderContext) -> Div {
        context.render(
            NewAdminList(
                table: {
                    if pageState.isPageOutOfRange {
                        context.render(
                            NewAdminListInvalidPageState(
                                pageState: pageState,
                                path: SystemJobRoutes.list.description
                            )
                        )
                    }
                    else if jobs.isEmpty {
                        context.render(
                            NewAdminListEmptyState(
                                message: search?.isEmpty ?? true
                                    ? "No worker jobs yet."
                                    : "No worker jobs match your search.",
                                icon: FeatherIcons.inbox(),
                                action: {
                                    if !(search?.isEmpty ?? true) {
                                        context.render(
                                            NewAdminButton(
                                                "Reset search",
                                                href: SystemJobRoutes.list
                                                    .description,
                                                style: .secondary
                                            )
                                        )
                                    }
                                }
                            )
                        )
                    }
                    else {
                        context.render(
                            NewAdminListShell(
                                table: Table {
                                    Thead {
                                        Tr {
                                            Th("Job").columnWidth(percent: 30)
                                            Th("Parameters")
                                            Th("Status").columnWidth(percent: 20)
                                            Th("Actions")
                                        }
                                    }
                                    Tbody {
                                        for job in jobs {
                                            context.render(
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
                    context.render(
                        NewAdminListSearch(
                            state: .init(
                                action: SystemJobRoutes.list.description,
                                placeholder: "Quick search worker jobs",
                                search: searchValue
                            )
                        )
                    )
                },
                pagination: {
                    context.render(
                        NewAdminListPagination(
                            state: .init(
                                path: SystemJobRoutes.list.description,
                                pageState: pageState,
                                search: searchValue
                            )
                        )
                    )
                }
            )
        )
    }
}
