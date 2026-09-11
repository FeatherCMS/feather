import CSS
import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

public struct NewAdminListEmptyState: Component {

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

    public func rules() -> [any Rule] {
        Media {
            Class("list-empty-state") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                JustifyContent(.center)
                TextAlign(.center)
                Gap(12.px)
                Padding(vertical: 40.px, horizontal: 24.px)
            }
            Custom(".list-empty-state p") {
                Margin(0)
            }
            Custom(".list-empty-state .list-empty-state-icon") {
                Width(40.px)
                Height(40.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(".list-empty-state .list-empty-state-action") {
                MarginTop(4.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            if let icon {
                icon.class("list-empty-state-icon")
            }
            P(message)
            if !action.isEmpty {
                Div {
                    for item in action {
                        item
                    }
                }
                .class("list-empty-state-action")
            }
        }
        .class("list-empty-state")
    }
}
