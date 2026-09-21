import CSS
import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct WebMenuItemGroup: Component {
    let content: [any FlowContent]

    init(
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.content = content()
    }

    static func groupSelectors() -> [any CSS.Selector] {
        [
            Class("web-menu-item-group") {
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(16.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
            }
        ]
    }

    func selectors() -> [any CSS.Selector] {
        Self.groupSelectors()
    }

    func html(context: inout BuilderContext) -> Div {
        Div {
            for item in content {
                item
            }
        }
        .class("web-menu-item-group")
    }
}
