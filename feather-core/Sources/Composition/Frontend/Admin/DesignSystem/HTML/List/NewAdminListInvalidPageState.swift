import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListInvalidPageState: Component {

    public let pageState: ListPageState
    public let path: String
    public let search: String

    public init(
        pageState: ListPageState,
        path: String,
        search: String = ""
    ) {
        self.pageState = pageState
        self.path = path
        self.search = search
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            P("Page \(pageState.page) does not exist.")
            P {
                Span("Go to ")
                A("page 1").href(location(page: 1))
                Span(" or ")
                A("page \(pageState.totalPages)")
                    .href(location(page: pageState.totalPages))
                Span(".")
            }
        }
        .class("list-invalid-page-state")
    }

    private func location(page: Int) -> String {
        guard var components = URLComponents(string: path) else {
            return path
        }
        var queryItems = [URLQueryItem(name: "page", value: String(page))]
        if !search.isEmpty {
            queryItems.append(URLQueryItem(name: "search", value: search))
        }
        components.queryItems = queryItems
        return components.string ?? path
    }
}
