import HTML
import CSS
import Hummingbird
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListPagination: Leaf {

    public func rules(
    ) -> [any Rule] {
        Media {
            Class("table-pagination") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                JustifyContent(.center)
                Gap(12.px)
                Padding(vertical: 12.px, horizontal: 14.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
            Custom(".table-pagination p") {
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                FontSize(0.86.rem)
                Margin(0)
            }
            Custom(".table-pagination .table-pagination-summary") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                Gap(2.px)
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
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(10.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                BoxSizing(.borderBox)
            }
            Custom(".table-pagination .page-controls") {
                Display(.flex)
                Gap(8.px)
            }
            Custom(".table-pagination .page-controls a") {
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(9.px)
                Padding(vertical: 8.px, horizontal: 12.px)
                TextDecoration(.none)
            }
            Custom(".table-pagination .page-controls a.disabled") {
                PointerEvents(.none)
                Opacity(0.45)
                Cursor(.default)
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
        public let page: Int
        public let pageSize: Int
        public let total: Int
        public let search: String
        public let queryItems: [QueryItem]

        public init(
            path: String,
            page: Int,
            pageSize: Int,
            total: Int,
            search: String,
            queryItems: [QueryItem] = []
        ) {
            self.path = path
            self.page = page
            self.pageSize = pageSize
            self.total = total
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

    public func html(
    ) -> Div {
        let extraQuerySuffix =
            state.queryItems
            .filter { !$0.value.isEmpty }
            .map { "&\($0.name)=\($0.value.queryEncoded())" }
            .joined()
        let searchSuffix =
            state.search.isEmpty ? "" : "&search=\(state.search.queryEncoded())"
        let filterSuffix = "\(searchSuffix)\(extraQuerySuffix)"
        let from =
            state.total == 0 ? 0 : ((state.page - 1) * state.pageSize) + 1
        let to = min(state.page * state.pageSize, state.total)
        let totalPages = max(
            1,
            (state.total + state.pageSize - 1) / state.pageSize
        )

        return Div {
            Div {
                if state.page > 1 {
                    A("First")
                        .href("\(state.path)?page=1\(filterSuffix)")
                }
                else {
                    A("First").href("#").class("disabled")
                }
                if state.page > 1 {
                    A("Prev")
                        .href(
                            "\(state.path)?page=\(state.page - 1)\(filterSuffix)"
                        )
                }
                else {
                    A("Prev").href("#").class("disabled")
                }

                Form {
                    Select {
                        for pageNumber in 1...totalPages {
                            if pageNumber == state.page {
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

                if state.page < totalPages {
                    A("Next")
                        .href(
                            "\(state.path)?page=\(state.page + 1)\(filterSuffix)"
                        )
                }
                else {
                    A("Next").href("#").class("disabled")
                }
                if state.page < totalPages {
                    A("Last")
                        .href("\(state.path)?page=\(totalPages)\(filterSuffix)")
                }
                else {
                    A("Last").href("#").class("disabled")
                }
            }
            .class("page-controls")

            Div {
                P(
                    "Showing \(from)-\(to) of \(state.total) entries · \(state.pageSize) per page"
                )
                P("Page \(state.page) of \(totalPages)")
            }
            .class("table-pagination-summary")
        }
        .class("table-pagination")
        .ariaLabel("Pagination")
    }
}
