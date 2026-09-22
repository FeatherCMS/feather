import AnalyticsAdminAPI
import AnalyticsContracts
import CSS
import FeatherAdmin
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
        let from: String
        let to: String
        let error: String?
    }

    let state: State

    func rules() -> [any Rule] {
        Media {
            Custom(".analytics-logs__intro") {
                Display(.flex)
                FlexDirection(.column)
                Gap(12.px)
                MinWidth(0.px)
            }
            Custom(".analytics-logs .admin-page-header") {
                MarginTop(0.px)
                MarginBottom(0.px)
            }
            Custom(".analytics-logs .admin-list") {
                MarginTop(20.px)
            }
            Custom(".analytics-logs__filter-form") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.stretch)
                Gap(14.px)
                Width(100.percent)
                MaxWidth(100.percent)
                BoxSizing(.borderBox)
                MarginBottom(0.px)
            }
            Custom(
                ".analytics-logs__date-range, "
                    + ".analytics-logs__filters-row, "
                    + ".analytics-logs__quicksearch-row"
            ) {
                Display(.flex)
                AlignItems(.center)
                Gap(12.px)
                Width(100.percent)
                MinWidth(0.px)
            }
            Custom(
                ".analytics-logs__date-range .new-admin-date-picker"
            ) {
                Width(50.percent)
                MinWidth(0.px)
                Flex(1, .number(1), .auto)
            }
            Custom(
                ".analytics-logs__date-range .new-admin-form-field-label"
            ) {
                Display(.none)
            }
            Custom(".analytics-logs__filters-row select") {
                Width(100.percent)
                MinWidth(0.px)
                BoxSizing(.borderBox)
                Flex(1, .number(1), .auto)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Padding(vertical: 8.px, horizontal: 10.px)
                FontSize(0.9.rem)
                PaddingRight(34.px)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value: "calc(100% - 19px) 50%, calc(100% - 14px) 50%"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(
                    name: "background-repeat",
                    value: "no-repeat"
                )
            }
            Custom(".analytics-logs__quicksearch-row .table-search-input") {
                Position(.relative)
                Flex(1, .number(1), .auto)
                Width(100.percent)
                MinWidth(0.px)
                BoxSizing(.borderBox)
            }
            Custom(
                ".analytics-logs__quicksearch-row input[type='search']"
            ) {
                Width(100.percent)
                MinWidth(0.px)
                BoxSizing(.borderBox)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Padding(vertical: 8.px, horizontal: 10.px)
                PaddingRight(34.px)
                FontSize(0.9.rem)
            }
            Custom(
                ".analytics-logs__quicksearch-row input[type='search']:focus"
            ) {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            }
            Custom(
                ".analytics-logs__quicksearch-row "
                    + "input[type='search']::-webkit-search-cancel-button"
            ) {
                Display(.none)
            }
            Custom(".analytics-logs__quicksearch-row .table-search-reset") {
                Position(.absolute)
                Top(50.percent)
                Right(9.px)
                Transform(.translateY((-50).percent))
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(24.px)
                Height(24.px)
                Padding(0.px)
                BorderRadius(999.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(1.15.rem)
                LineHeight(1)
                TextDecoration(.none)
            }
            Custom(
                ".analytics-logs__quicksearch-row "
                    + ".table-search-reset:hover"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Outline(0.px, .none)
            }
            Custom(
                ".analytics-logs__quicksearch-row button[type='submit']"
            ) {
                Flex(0, .number(0), .auto)
                Cursor(.pointer)
            }
        }
        Media(.maxWidth(768.px)) {
            Custom(
                ".analytics-logs__date-range, "
                    + ".analytics-logs__filters-row"
            ) {
                FlexWrap(.wrap)
            }
            Custom(
                ".analytics-logs__date-range .new-admin-date-picker, "
                    + ".analytics-logs__filters-row select"
            ) {
                UnsafeRawProperty(name: "flex", value: "1 1 180px")
            }
            Custom(".analytics-logs__quicksearch-row") {
                FlexWrap(.nowrap)
            }
        }
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.canAccess {
                context.build(
                    NewAdminBreadcrumb(links: AnalyticsAdminRoutes.breadcrumb)
                )
                context.build(
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
                Div {
                    context.build(
                        NewAdminBreadcrumb(
                            links: AnalyticsAdminRoutes.breadcrumb
                        )
                    )
                    context.build(
                        NewAdminPageHeader(
                            state: .init(
                                title: "Analytics logs",
                                description:
                                    "Browse tracked request log records."
                            )
                        )
                    )
                }
                .class("analytics-logs__intro")
                if let error = state.error {
                    P(error).class("new-admin-form__error")
                }
                context.build(content(context: &context))
            }
        }
        .class("cms-section", "analytics-logs")
    }

    private func content(context: inout BuilderContext) -> NewAdminList {
        let filters = filterForm(context: &context)
        let hasActiveQuery =
            !state.search.isEmpty || !state.source.isEmpty
            || !state.method.isEmpty || !state.responseCode.isEmpty
            || !state.from.isEmpty || !state.to.isEmpty
        return NewAdminList(
            table: {
                if state.pageState.isPageOutOfRange {
                    context.build(
                        NewAdminListInvalidPageState(
                            pageState: state.pageState,
                            path: AnalyticsAdminRoutes.logs.description
                        )
                    )
                }
                else if state.logs.isEmpty {
                    context.build(
                        NewAdminListNoResultsState(
                            message: hasActiveQuery
                                ? "No analytics logs match your search."
                                : "No analytics logs yet.",
                            icon: FeatherIcons.activity(),
                            action: {
                                if hasActiveQuery {
                                    context.build(
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
                    context.build(
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
                                                context.build(
                                                    NewAdminChip(
                                                        label: log.method,
                                                        color: .blue
                                                    )
                                                )
                                            }
                                            .data("label", "Method")
                                            Td {
                                                context.build(
                                                    statusChip(log.responseCode)
                                                )
                                            }
                                            .data("label", "Status")
                                            Td {
                                                context.build(
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
                                            context.build(
                                                NewAdminListRowActions(
                                                    label: "Actions",
                                                    actions: [
                                                        .init(
                                                            "View",
                                                            href:
                                                                AnalyticsAdminRoutes
                                                                .log(
                                                                    RouterPath(
                                                                        log.id
                                                                    )
                                                                )
                                                                .description,
                                                            style: .ghost(
                                                                .primary
                                                            ),
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
                filters
            },
            pagination: {
                context.build(
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
                                .init(name: "from", value: state.from),
                                .init(name: "to", value: state.to),
                            ]
                        )
                    )
                )
            }
        )
    }

    private func filterForm(
        context: inout BuilderContext
    ) -> Form {
        Form {
            Div {
                context.build(
                    NewAdminFormFieldDatePicker(
                        state: .init(
                            name: "from",
                            label: "From",
                            value: state.from,
                            placeholder: "Start date & time"
                        )
                    )
                )
                context.build(
                    NewAdminFormFieldDatePicker(
                        state: .init(
                            name: "to",
                            label: "To",
                            value: state.to,
                            placeholder: "End date & time"
                        )
                    )
                )
            }
            .class("analytics-logs__date-range")
            Div {
                Select {
                    Option("All sources").value("")
                        .if(state.source.isEmpty) { $0.selected() }
                    Option("Backend API").value("backend_api")
                        .if(state.source == "backend_api") { $0.selected() }
                    Option("Web app").value("web_app")
                        .if(state.source == "web_app") { $0.selected() }
                }
                .name("source")
                Select {
                    for option in [
                        "", "GET", "POST", "PUT", "PATCH", "DELETE",
                        "HEAD", "OPTIONS",
                    ] {
                        Option(option.isEmpty ? "All methods" : option)
                            .value(option)
                            .if(state.method == option) { $0.selected() }
                    }
                }
                .name("method")
                Select {
                    for option in [
                        "", "200", "201", "204", "301", "302", "304",
                        "400", "401", "403", "404", "409", "422", "429",
                        "500", "502", "503",
                    ] {
                        Option(option.isEmpty ? "All statuses" : option)
                            .value(option)
                            .if(state.responseCode == option) { $0.selected() }
                    }
                }
                .name("responseCode")
            }
            .class("analytics-logs__filters-row")
            Div {
                Div {
                    Input()
                        .type(.search)
                        .name("search")
                        .value(state.search)
                        .placeholder("Quick search path")
                        .ariaLabel("Quick search path")
                    if !state.search.isEmpty {
                        A("×")
                            .href(AnalyticsAdminRoutes.logs.description)
                            .ariaLabel("Reset search")
                            .title("Reset search")
                            .class("table-search-reset")
                    }
                }
                .class("table-search-input")
                context.build(
                    NewAdminSubmitButton(
                        "Search",
                        style: .ghost(.primary),
                        isRowButton: true
                    )
                )
            }
            .class("analytics-logs__quicksearch-row")
        }
        .method(.get)
        .action(AnalyticsAdminRoutes.logs.description)
        .class("analytics-logs__filter-form")
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
