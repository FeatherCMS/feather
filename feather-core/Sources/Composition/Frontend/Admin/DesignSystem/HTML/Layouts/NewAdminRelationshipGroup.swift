public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminRelationshipGroup: Component {
    public let content: [any FlowContent]

    public init(
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.content = content()
    }

    public static func groupSelectors() -> [any Selector] {
        [
            Class("new-admin-relationship-group") {
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

    public func selectors() -> [any Selector] {
        Self.groupSelectors()
    }

    public func html(context _: inout BuilderContext) -> Div {
        Div {
            for item in content {
                item
            }
        }
        .class("new-admin-relationship-group")
    }
}
