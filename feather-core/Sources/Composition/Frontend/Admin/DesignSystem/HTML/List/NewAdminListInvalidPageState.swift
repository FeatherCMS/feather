import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListInvalidPageState: Component {

    public let pageState: ListPageState
    public let path: String

    public init(
        pageState: ListPageState,
        path: String
    ) {
        self.pageState = pageState
        self.path = path
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            P("Page \(pageState.page) does not exist.")
            P {
                Span("Go to ")
                A("page 1").href("\(path)?page=1")
                Span(" or ")
                A("page \(pageState.totalPages)")
                    .href("\(path)?page=\(pageState.totalPages)")
                Span(".")
            }
        }
        .class("list-invalid-page-state")
    }
}
