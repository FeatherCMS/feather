import HTML
import Hummingbird
import SGML
import WebStandards

struct ListTablePagination: Component, FlowContent {

    struct State {
        let path: String
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let queryItems: [(String, String)]

        init(
            path: String,
            page: Int,
            pageSize: Int,
            total: Int,
            search: String,
            queryItems: [(String, String)] = []
        ) {
            self.path = path
            self.page = page
            self.pageSize = pageSize
            self.total = total
            self.search = search
            self.queryItems = queryItems
        }
    }

    let state: State

    func content() -> some BasicTag {
        let extraQuerySuffix =
            state.queryItems
            .filter { !$0.1.isEmpty }
            .map { "&\($0.0)=\($0.1.queryEncoded())" }
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
                    for item in state.queryItems where !item.1.isEmpty {
                        Input()
                            .type(.hidden)
                            .name(item.0)
                            .value(item.1)
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
