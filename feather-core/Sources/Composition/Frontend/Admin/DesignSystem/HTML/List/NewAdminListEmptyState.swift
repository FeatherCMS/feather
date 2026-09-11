import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListEmptyState: Component {

    public let message: String

    public init(
        message: String
    ) {
        self.message = message
    }

    public func html(context: inout RenderContext) -> Div {
        return Div {
            P(message)
        }
        .class("list-empty-state")
    }
}
