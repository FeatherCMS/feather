import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminListRowCheckbox: Component {

    public let id: String

    public init(
        id: String
    ) {
        self.id = id
    }

    public func selectors() -> [any Selector] {
        [
            Custom(".select-cell input[type='checkbox']") {
                Width(18.px)
                Height(18.px)
                UnsafeRawProperty(name: "appearance", value: "none")
                AccentColor(.variable(TokenKey.Colors.Link.hover))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(4.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Cursor(.pointer)
            },
            Custom(".select-cell input[type='checkbox']:focus-visible") {
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom(".select-cell input[type='checkbox']:checked") {
                Background(.variable(TokenKey.Colors.Link.default))
                BorderColor(.variable(TokenKey.Colors.Link.default))
            },
        ]
    }

    public func html(context: inout RenderContext) -> Td {
        Td {
            Input()
                .type(.checkbox)
                .name("ids")
                .value(id)
                .ariaLabel("Select row")
                .class("select-row")
        }
        .data("label", "Select")
        .class("select-cell")
    }
}
