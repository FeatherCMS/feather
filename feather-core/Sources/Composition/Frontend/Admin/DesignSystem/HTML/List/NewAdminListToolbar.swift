import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListToolbar: Leaf {

    public func rules(
    ) -> [any Rule] {
        Media {
            Class("list-toolbar") {
                Display(.flex)
                AlignItems(.flexEnd)
                JustifyContent(.spaceBetween)
                Gap(12.px)
                FlexWrap(.wrap)
                MarginBottom(10.px)
            }
        }
    }

    public let content: [any FlowContent]

    public init(
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.content = content()
    }

    public func html(
    ) -> Div {
        Div {
            for item in content {
                item
            }
        }
        .class("list-toolbar")
    }
}
