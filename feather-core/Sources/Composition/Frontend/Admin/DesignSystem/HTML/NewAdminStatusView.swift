import CSS
import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

/// A page-level message for states where the requested admin content cannot be shown.
public struct NewAdminStatusView: Component {

    public struct State: Sendable {
        public let title: String
        public let message: String

        public init(
            title: String,
            message: String
        ) {
            self.title = title
            self.message = message
        }
    }

    public let state: State
    public let icon: SVG?
    public let action: NewAdminButton?

    public init(
        state: State,
        icon: SVG? = nil,
        action: NewAdminButton? = nil
    ) {
        self.state = state
        self.icon = icon
        self.action = action
    }

    public func rules() -> [any Rule] {
        Media {
            Class("admin-status-view") {
                Display(.flex)
                FlexDirection(.row)
                AlignItems(.center)
                JustifyContent(.flexStart)
                TextAlign(.left)
                Gap(12.px)
                Padding(vertical: 12.px, horizontal: 12.px)
                PaddingRight(44.px)
                Width(100.percent)
                BoxSizing(.borderBox)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                UnsafeRawProperty(
                    name: "background-image",
                    value:
                        "linear-gradient(45deg, transparent 50%, currentColor 50%), linear-gradient(135deg, currentColor 50%, transparent 50%)"
                )
                UnsafeRawProperty(
                    name: "background-position",
                    value:
                        "calc(100% - 25px) 50%, calc(100% - 20px) 50%"
                )
                UnsafeRawProperty(
                    name: "background-size",
                    value: "5px 5px"
                )
                UnsafeRawProperty(
                    name: "background-repeat",
                    value: "no-repeat"
                )
            }
            Custom(".admin-status-view h1, .admin-status-view p") {
                Margin(0)
            }
            Custom(".admin-status-view-content") {
                Display(.flex)
                FlexDirection(.column)
                Gap(4.px)
                FlexGrow(1)
            }
            Custom(".admin-status-view h1") {
                FontSize(1.rem)
                LineHeight(1.2)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom(".admin-status-view p") {
                FontSize(0.9.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                LineHeight(1.5)
            }
            Custom(".admin-status-view-icon") {
                Display(.block)
                Width(20.px)
                Height(20.px)
                FlexShrink(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            }
            Custom(".admin-status-view .button") {
                MarginLeft(.auto)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            if let icon {
                icon.class("admin-status-view-icon")
            }
            Div {
                H1(state.title)
                P(state.message)
            }
            .class("admin-status-view-content")
            if let action { context.render(action) }
        }
        .class("admin-status-view")
    }
}
