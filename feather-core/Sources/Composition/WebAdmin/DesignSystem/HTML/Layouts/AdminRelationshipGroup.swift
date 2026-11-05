public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct AdminRelationshipGroup: Component {
    public let pageHeader: AdminPageHeader.State
    public let content: [any FlowContent]

    public init(
        pageHeader: AdminPageHeader.State,
        @Builder<FlowContent> content: () -> [any FlowContent]
    ) {
        self.pageHeader = pageHeader
        self.content = content()
    }

    public static func groupSelectors() -> [any Selector] {
        [
            Class("admin-relationship-group") {
                Display(.flex)
                FlexDirection(.column)
                Gap(18.px)
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
            context.build(AdminPageHeader(state: pageHeader))
            for item in content {
                item
            }
        }
        .class("admin-relationship-group")
    }
}
