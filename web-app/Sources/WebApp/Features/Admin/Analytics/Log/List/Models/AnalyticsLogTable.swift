import AdminOpenAPI
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import SGML
import WebStandards

struct AnalyticsLogTable: Component {

    private static let methodOptions = [
        ("", "All methods"),
        ("GET", "GET"),
        ("POST", "POST"),
        ("PUT", "PUT"),
        ("PATCH", "PATCH"),
        ("DELETE", "DELETE"),
        ("HEAD", "HEAD"),
        ("OPTIONS", "OPTIONS"),
    ]

    private static let statusOptions = [
        ("", "All statuses"),
        ("200", "200 OK"),
        ("201", "201 Created"),
        ("204", "204 No Content"),
        ("301", "301 Moved Permanently"),
        ("302", "302 Found"),
        ("304", "304 Not Modified"),
        ("400", "400 Bad Request"),
        ("401", "401 Unauthorized"),
        ("403", "403 Forbidden"),
        ("404", "404 Not Found"),
        ("409", "409 Conflict"),
        ("422", "422 Unprocessable Entity"),
        ("429", "429 Too Many Requests"),
        ("500", "500 Internal Server Error"),
        ("502", "502 Bad Gateway"),
        ("503", "503 Service Unavailable"),
    ]

    struct State {
        let canAccess: Bool
        let permissions: Set<String>
        let logs: [Components.Schemas.AnalyticsLogListItemSchema]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let source: String
        let method: String
        let responseCode: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Analytics logs")
                Form {
                    Div {
                        Input()
                            .type(.search)
                            .name("search")
                            .placeholder("Quick search path")
                            .value(state.search)
                        Select {
                            Option("All sources").value("")
                            if state.source == "backend_api" {
                                Option("Backend API")
                                    .value("backend_api")
                                    .selected()
                            }
                            else {
                                Option("Backend API")
                                    .value("backend_api")
                            }
                            if state.source == "web_app" {
                                Option("Web app")
                                    .value("web_app")
                                    .selected()
                            }
                            else {
                                Option("Web app")
                                    .value("web_app")
                            }
                        }
                        .name("source")
                        Select {
                            for option in Self.methodOptions {
                                if state.method == option.0 {
                                    Option(option.1)
                                        .value(option.0)
                                        .selected()
                                }
                                else {
                                    Option(option.1)
                                        .value(option.0)
                                }
                            }
                        }
                        .name("method")
                        Select {
                            for option in Self.statusOptions {
                                if state.responseCode == option.0 {
                                    Option(option.1)
                                        .value(option.0)
                                        .selected()
                                }
                                else {
                                    Option(option.1)
                                        .value(option.0)
                                }
                            }
                        }
                        .name("responseCode")
                        Button("Search").type(.submit)
                        A("Reset")
                            .href("/admin/analytics/logs/")
                    }
                    .class("table-search-form", "analytics-log-search-form")
                }
                .method(.get)
                .action("/admin/analytics/logs/")

                if state.logs.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/analytics/logs/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/analytics/logs/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No analytics logs yet."
                                : "No analytics logs match your search."
                        )
                    }
                }
                else {
                    ListTableShell(
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
                                        Td(log.method)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Method"
                                            )
                                        Td("\(log.responseCode)")
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Status"
                                            )
                                        Td(log.source)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Source"
                                            )
                                        Td(log.path)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Path"
                                            )
                                        Td(
                                            DateFormatting.formatUnixTimestamp(
                                                log.createdAt
                                            )
                                        )
                                        .setAttribute(
                                            name: "data-label",
                                            value: "Created"
                                        )
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/analytics/logs/\(log.id)/",
                                                        className: nil,
                                                        permission:
                                                            "analytics:logs:list"
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
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/analytics/logs/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search,
                            queryItems: [
                                ("source", state.source),
                                ("method", state.method),
                                ("responseCode", state.responseCode),
                            ]
                        )
                    )
                }
            }
        }
        .class("cms-section")
    }
}
