import CSS
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListPagination: Component {

    public func rules() -> [any Rule] {
        Media {
            Class("table-pagination") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                JustifyContent(.center)
                Gap(12.px)
                Padding(vertical: 12.px, horizontal: 14.px)
            }
            Custom(".table-pagination p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.82.rem)
                Margin(0)
            }
            Custom(".table-pagination .table-pagination-summary p:first-child")
            {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.86.rem)
                FontWeight(.normal)
            }
            Custom(".table-pagination .table-pagination-summary") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                Gap(5.px)
                TextAlign(.center)
            }
            Custom(".table-pagination .pagination-page-form") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
                FlexWrap(.wrap)
            }
            Custom(".table-pagination .pagination-page-select") {
                MinWidth(4.75.rem)
                Width(4.75.rem)
                Height(34.px)
                Padding(vertical: 0.px, horizontal: 12.px)
                PaddingRight(30.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(10.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                BoxSizing(.borderBox)
                FontSize(0.9.rem)
                Cursor(.pointer)
                UnsafeRawProperty(name: "appearance", value: "none")
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value: "calc(100% - 15px) 14px, calc(100% - 10px) 14px"
                )
                UnsafeRawProperty(name: "background-size", value: "5px 5px")
                UnsafeRawProperty(name: "background-repeat", value: "no-repeat")
            }
            Custom(".table-pagination .page-controls") {
                Display(.flex)
                Gap(8.px)
            }
            Custom(".table-pagination .pagination-page-select:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            }
        }
        Media(.maxWidth(768.px)) {
            Class("table-pagination") {
                Width(100.percent)
                BoxSizing(.borderBox)
            }
            Custom(".table-pagination > .page-controls") {
                JustifyContent(.center)
                FlexWrap(.wrap)
            }
        }
    }

    public struct QueryItem: Sendable {
        public let name: String
        public let value: String

        public init(
            name: String,
            value: String
        ) {
            self.name = name
            self.value = value
        }
    }

    public struct State: Sendable {
        public let path: String
        public let pageState: NewAdminListPageState
        public let search: String
        public let queryItems: [QueryItem]

        public init(
            path: String,
            pageState: NewAdminListPageState,
            search: String,
            queryItems: [QueryItem] = []
        ) {
            self.path = path
            self.pageState = pageState
            self.search = search
            self.queryItems = queryItems
        }
    }

    public let state: State

    public init(
        state: State
    ) {
        self.state = state
    }

    public func html(context: inout RenderContext) -> Div {
        let extraQuerySuffix =
            state.queryItems
            .filter { !$0.value.isEmpty }
            .map { "&\($0.name)=\($0.value.queryEncoded())" }
            .joined()
        let searchSuffix =
            state.search.isEmpty ? "" : "&search=\(state.search.queryEncoded())"
        let filterSuffix = "\(searchSuffix)\(extraQuerySuffix)"
        let from =
            state.pageState.total == 0
            ? 0
            : ((state.pageState.page - 1) * state.pageState.pageSize) + 1
        let to = min(
            state.pageState.page * state.pageState.pageSize,
            state.pageState.total
        )
        let totalPages = state.pageState.totalPages

        return Div {
            Div {
                if state.pageState.page > 1 {
                    context.render(
                        NewAdminRowButton(
                            "First",
                            href: "\(state.path)?page=1\(filterSuffix)",
                            style: .ghost(.secondary)
                        )
                    )
                }
                else {
                    context.render(NewAdminRowButton("First", style: .disabled))
                }
                if state.pageState.page > 1 {
                    context.render(
                        NewAdminRowButton(
                            "Prev",
                            href:
                                "\(state.path)?page=\(state.pageState.page - 1)\(filterSuffix)",
                            style: .ghost(.secondary)
                        )
                    )
                }
                else {
                    context.render(NewAdminRowButton("Prev", style: .disabled))
                }

                Form {
                    Select {
                        for pageNumber in 1...totalPages {
                            if pageNumber == state.pageState.page {
                                Option("\(pageNumber)")
                                    .value("\(pageNumber)")
                                    .selected()
                            }
                            else {
                                Option("\(pageNumber)")
                                    .value("\(pageNumber)")
                            }
                        }
                    }
                    .name("page")
                    .id("tablePaginationPage")
                    .ariaLabel("Go to page")
                    .onChange("this.form.submit()")
                    .class("pagination-page-select")
                    if !state.search.isEmpty {
                        Input()
                            .type(.hidden)
                            .name("search")
                            .value(state.search)
                    }
                    for item in state.queryItems where !item.value.isEmpty {
                        Input()
                            .type(.hidden)
                            .name(item.name)
                            .value(item.value)
                    }
                }
                .method(.get)
                .action(state.path)
                .class("pagination-page-form")

                if state.pageState.page < totalPages {
                    context.render(
                        NewAdminRowButton(
                            "Next",
                            href:
                                "\(state.path)?page=\(state.pageState.page + 1)\(filterSuffix)",
                            style: .ghost(.secondary)
                        )
                    )
                }
                else {
                    context.render(NewAdminRowButton("Next", style: .disabled))
                }
                if state.pageState.page < totalPages {
                    context.render(
                        NewAdminRowButton(
                            "Last",
                            href:
                                "\(state.path)?page=\(totalPages)\(filterSuffix)",
                            style: .ghost(.secondary)
                        )
                    )
                }
                else {
                    context.render(NewAdminRowButton("Last", style: .disabled))
                }
            }
            .class("page-controls")

            Div {
                P(
                    "Showing \(from)-\(to) of \(state.pageState.total) entries · \(state.pageState.pageSize) per page"
                )
                P("Page \(state.pageState.page) of \(totalPages)")
            }
            .class("table-pagination-summary")
        }
        .class("table-pagination")
        .ariaLabel("Pagination")
    }
}
