public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public enum AdminDialogSize: Sendable {
    case small
    case large
}

public struct AdminDialog<Content: Component>: Component {
    public let title: String
    public let content: Content
    public let size: AdminDialogSize

    public init(
        title: String,
        content: Content,
        size: AdminDialogSize = .small
    ) {
        self.title = title
        self.content = content
        self.size = size
    }

    public func rules() -> [any Rule] {
        Media {
            Custom("dialog.admin-dialog") {
                Position(.fixed)
                UnsafeRawProperty(name: "inset", value: "0")
                Margin(.auto)
                Width(92.percent)
                MaxWidth(640.px)
                MaxHeight(90.vh)
                Padding(0.px)
                Border(0)
                BorderRadius(18.px)
                Overflow(.hidden)
                OverflowY(.auto)
                Background(color: .transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom("dialog.admin-dialog::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(128, 128, 128, 0.46)")
                    )
                )
                BackdropFilter(.blur(12.px))
            }
            Custom("dialog.admin-dialog.admin-dialog--large") {
                Width(80.percent)
                MaxWidth(1400.px)
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Custom("dialog.admin-dialog::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(0, 0, 0, 0.68)")
                    )
                )
            }
        }
        Media {
            Class("admin-dialog__panel") {
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
                Background(
                    color: .color(CSSColor(stringLiteral: "#ffffff"))
                )
                BoxShadow(
                    0.px,
                    18.px,
                    blur: 48.px,
                    spread: 0.px,
                    color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.24)")
                )
            }
            Custom(
                "html.admin-dialog-open, html.admin-dialog-open body"
            ) {
                Overflow(.hidden)
            }
            Class("admin-dialog__header") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(16.px)
            }
            Custom(".admin-dialog__header h2") {
                Margin(0.px)
                FontSize(1.35.rem)
                LineHeight(1.2)
            }
            Class("admin-dialog__close") {
                FlexShrink(0)
            }
            Custom(".admin-dialog__panel .cms-section") {
                Padding(0.px)
            }
            Custom(".admin-dialog__panel .admin-form") {
                MarginTop(0.px)
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Custom(".admin-dialog__panel") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
        }
    }

    public func html(context: inout BuilderContext) -> Dialog {
        Dialog {
            Div {
                Div {
                    H2(title)
                    context.build(
                        AdminControlButton(
                            "Close",
                            style: .ghost(.secondary)
                        )
                    )
                    .class("admin-dialog__close")
                    .data("admin-dialog-close", "")
                }
                .class("admin-dialog__header")

                context.build(content)
            }
            .class("admin-dialog__panel")
        }
        .class("admin-dialog")
        .if(size == .large) { $0.class("admin-dialog--large") }
        .data("admin-dialog", "")
        .ariaLabel(title)
    }
}
