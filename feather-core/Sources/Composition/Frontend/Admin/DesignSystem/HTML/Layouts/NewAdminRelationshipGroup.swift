public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminRelationshipGroup: Component {
    public let pageHeader: NewAdminPageHeader.State
    public let content: [any FlowContent]

    public init(
        pageHeader: NewAdminPageHeader.State,
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.pageHeader = pageHeader
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

    public func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(NewAdminPageHeader(state: pageHeader))
            for item in content {
                item
            }
        }
        .class("new-admin-relationship-group")
    }
}
