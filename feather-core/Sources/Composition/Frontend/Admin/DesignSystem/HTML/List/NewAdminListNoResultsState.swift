import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

public struct NewAdminListNoResultsState: Component {

    public let message: String
    public let icon: SVG?
    public let action: [any FlowContent]

    public init(
        message: String,
        icon: SVG? = nil,
        @Builder<FlowContent> action: () -> [any FlowContent] = { [] }
    ) {
        self.message = message
        self.icon = icon
        self.action = action()
    }

    public func html(context: inout BuilderContext) -> Div {
        context.build(
            NewAdminListEmptyState(
                message: message,
                icon: icon,
                action: { action }
            )
        )
    }
}
