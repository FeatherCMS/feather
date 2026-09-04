import FeatherAdmin
import HTML
import SGML
import SystemAdminAPI
import WebComponents
import WebBuilders

struct SystemJobTable: Leaf {
    struct State {
        let jobs: [Components.Schemas.SystemJobSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let permissions: Set<String>
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Worker jobs")
            ListTableSearchForm(
                state: .init(
                    action: "/admin/system/jobs/",
                    placeholder: "Quick search worker jobs",
                    search: state.search
                )
            ).html()

            if state.jobs.isEmpty {
                let totalPages = max(
                    1,
                    (state.total + state.pageSize - 1) / state.pageSize
                )
                if state.total > 0 && state.page > totalPages {
                    P("Page (state.page) does not exist.")
                    P {
                        Span("Go to ")
                        A("page 1").href("/admin/system/jobs/?page=1")
                        Span(" or ")
                        A("page (totalPages)")
                            .href("/admin/system/jobs/?page=(totalPages)")
                        Span(".")
                    }
                }
                else {
                    P(
                        state.search.isEmpty
                            ? "No worker jobs found."
                            : "No worker jobs match your search."
                    )
                }
            }
            else {
                ListTableShell(
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
                            for job in state.jobs {
                                let payload = SystemJobPayload(job: job)
                                Tr {
                                    Td(payload.name).data("label", "Job")
                                    Td(
                                        payload.parameterSummary.isEmpty
                                            ? "—" : payload.parameterSummary
                                    )
                                    .data("label", "Parameters")
                                    Td(statusLabel(job.status))
                                        .data("label", "Status")
                                    ListTableRowActions(
                                        state: .init(
                                            label: "Actions",
                                            actions: [
                                                .init(
                                                    title: "Details",
                                                    href:
                                                        "/admin/system/jobs/\(job.id)/",
                                                    className: nil,
                                                    permission:
                                                        "system:jobs:read"
                                                )
                                            ],
                                            permissions: state.permissions
                                        )
                                    ).html()
                                }
                            }
                        }
                    }
                    .class("cms-table", "action-table")
                ).html()
                ListTablePagination(
                    state: .init(
                        path: "/admin/system/jobs/",
                        page: state.page,
                        pageSize: state.pageSize,
                        total: state.total,
                        search: state.search
                    )
                ).html()
            }
        }
        .class("cms-section")
    }

    private func statusLabel(_ status: Int) -> String {
        switch status {
        case 0: "Pending"
        case 1: "Processing"
        case 2: "Failed"
        case 3: "Cancelled"
        case 5: "Completed"
        default: "Unknown (\(status))"
        }
    }
}
