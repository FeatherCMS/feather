public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminDialog<Content: Component>: Component {
    public let title: String
    public let content: Content

    public init(
        title: String,
        content: Content
    ) {
        self.title = title
        self.content = content
    }

    public func rules() -> [any Rule] {
        Media {
            Custom("dialog.new-admin-dialog") {
                Width(92.percent)
                MaxWidth(640.px)
                Padding(0.px)
                Border(0)
                Background(color: .transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom("dialog.new-admin-dialog::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(0, 0, 0, 0.45)")
                    )
                )
            }
            Class("new-admin-dialog__panel") {
                Display(.flex)
                FlexDirection(.column)
                Gap(18.px)
                Padding(24.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BorderRadius(18.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                BoxShadow(
                    0.px,
                    18.px,
                    blur: 48.px,
                    spread: 0.px,
                    color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.24)")
                )
            }
            Class("new-admin-dialog__header") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(16.px)
            }
            Custom(".new-admin-dialog__header h2") {
                Margin(0.px)
                FontSize(1.35.rem)
                LineHeight(1.2)
            }
            Class("new-admin-dialog__close") {
                FlexShrink(0)
            }
            Custom(".new-admin-dialog__panel .cms-section") {
                Padding(0.px)
            }
            Custom(".new-admin-dialog__panel .new-admin-form") {
                MarginTop(0.px)
            }
        }
    }

    public func html(context: inout BuilderContext) -> Dialog {
        Dialog {
            Div {
                Div {
                    H2(title)
                    context.build(
                        NewAdminControlButton(
                            "Close",
                            style: .ghost(.secondary)
                        )
                    )
                    .class("new-admin-dialog__close")
                    .data("admin-dialog-close", "")
                }
                .class("new-admin-dialog__header")

                context.build(content)
            }
            .class("new-admin-dialog__panel")
        }
        .class("new-admin-dialog")
        .data("admin-dialog", "")
        .ariaLabel(title)
    }
}
