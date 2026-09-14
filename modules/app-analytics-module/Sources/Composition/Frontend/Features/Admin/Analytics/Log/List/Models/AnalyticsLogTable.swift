import AnalyticsAdminAPI
import AnalyticsContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct AnalyticsLogTable: Component {
    struct State {
        let canAccess: Bool
        let permissions: NewAdminListActions
        let logs: [Components.Schemas.AnalyticsLogListItemSchema]
        let pageState: NewAdminListPageState
        let search: String
        let source: String
        let method: String
        let responseCode: String
        let error: String?
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(links: AnalyticsAdminRoutes.breadcrumb)
            )
            if !state.canAccess {
                context.render(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message:
                                "Your account cannot access analytics logs."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            else {
                context.render(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Analytics logs",
                            description: "Browse tracked request log records."
                        )
                    )
                )
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.render(content(context: &context))
            }
        }
        .class("cms-section")
    }

    private func content(context: inout RenderContext) -> NewAdminList {
        let hasActiveQuery =
            !state.search.isEmpty || !state.source.isEmpty
            || !state.method.isEmpty || !state.responseCode.isEmpty
        return NewAdminList(
            table: {
                if state.pageState.isPageOutOfRange {
                    context.render(
                        NewAdminListInvalidPageState(
                            pageState: state.pageState,
                            path: AnalyticsAdminRoutes.logs.description
                        )
                    )
                }
                else if state.logs.isEmpty {
                    context.render(
                        NewAdminListNoResultsState(
                            message: hasActiveQuery
                                ? "No analytics logs match your search."
                                : "No analytics logs yet.",
                            icon: FeatherIcons.activity(),
                            action: {
                                if hasActiveQuery {
                                    context.render(
                                        NewAdminButton(
                                            "Reset search",
                                            href: AnalyticsAdminRoutes.logs
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
                            layout: .init(
                                name: "analytics-logs",
                                columns: [
                                    .fixed(90), .fixed(100), .fixed(120),
                                    .fraction(2), .fraction(1), .fixed(160),
                                ]
                            ),
                            table: Table {
                                Thead {
                                    Tr {
                                        Th("Method")
                                        Th("Status")
                                        Th("Source")
                                        Th("Path")
                                        Th("Created")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for log in state.logs {
                                        Tr {
                                            Td {
                                                context.render(
                                                    NewAdminChip(
                                                        label: log.method,
                                                        color: .blue
                                                    )
                                                )
                                            }
                                            .data("label", "Method")
                                            Td {
                                                context.render(
                                                    statusChip(log.responseCode)
                                                )
                                            }
                                            .data("label", "Status")
                                            Td {
                                                context.render(
                                                    sourceChip(log.source)
                                                )
                                            }
                                            .data("label", "Source")
                                            Td(log.path).data("label", "Path")
                                            Td(
                                                DateFormatting
                                                    .formatUnixTimestamp(
                                                        log.createdAt
                                                    )
                                            )
                                            .data("label", "Created")
                                            context.render(
                                                NewAdminListRowActions(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            "Details",
                                                            href:
                                                                AnalyticsAdminRoutes
                                                                .log(
                                                                    RouterPath(
                                                                        log.id
                                                                    )
                                                                )
                                                                .description,
                                                            permission:
                                                                AnalyticsPermissions
                                                                .Logs.list
                                                        )
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
                        )
                    )
                }
            },
            search: {
                context.render(
                    NewAdminListSearch(
                        state: .init(
                            action: AnalyticsAdminRoutes.logs.description,
                            placeholder: "Quick search path",
                            search: state.search,
                            queryItems: [
                                .init(name: "source", value: state.source),
                                .init(name: "method", value: state.method),
                                .init(
                                    name: "responseCode",
                                    value: state.responseCode
                                ),
                            ]
                        ),
                        additionalFields: { filters }
                    )
                )
            },
            pagination: {
                context.render(
                    NewAdminListPagination(
                        state: .init(
                            path: AnalyticsAdminRoutes.logs.description,
                            pageState: state.pageState,
                            search: state.search,
                            queryItems: [
                                .init(name: "source", value: state.source),
                                .init(name: "method", value: state.method),
                                .init(
                                    name: "responseCode",
                                    value: state.responseCode
                                ),
                            ]
                        )
                    )
                )
            }
        )
    }

    private var filters: [any FlowContent] {
        [
            Select {
                Option("All sources").value("")
                    .if(state.source.isEmpty) { $0.selected() }
                Option("Backend API").value("backend_api")
                    .if(state.source == "backend_api") { $0.selected() }
                Option("Web app").value("web_app")
                    .if(state.source == "web_app") { $0.selected() }
            }
            .name("source"),
            Select {
                for option in [
                    "", "GET", "POST", "PUT", "PATCH", "DELETE", "HEAD",
                    "OPTIONS",
                ] {
                    Option(option.isEmpty ? "All methods" : option)
                        .value(option)
                        .if(state.method == option) { $0.selected() }
                }
            }
            .name("method"),
            Select {
                for option in [
                    "", "200", "201", "204", "301", "302", "304", "400", "401",
                    "403", "404", "409", "422", "429", "500", "502", "503",
                ] {
                    Option(option.isEmpty ? "All statuses" : option)
                        .value(option)
                        .if(state.responseCode == option) { $0.selected() }
                }
            }
            .name("responseCode"),
        ]
    }

    private func statusChip(_ status: Int) -> NewAdminChip {
        let color: NewAdminChip.ColorName =
            status >= 500
            ? .red
            : (status >= 400 ? .orange : (status >= 300 ? .yellow : .green))
        return .init(label: "\(status)", color: color)
    }

    private func sourceChip(_ source: String) -> NewAdminChip {
        .init(
            label: source == "web_app" ? "Web app" : "Backend API",
            color: source == "web_app" ? .purple : .blue
        )
    }
}
