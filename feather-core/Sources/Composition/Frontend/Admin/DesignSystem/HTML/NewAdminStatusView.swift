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

    public init(
        state: State,
        icon: SVG? = nil
    ) {
        self.state = state
        self.icon = icon
    }

    public func rules() -> [any Rule] {
        Media {
            Class("admin-status-view") {
                Display(.flex)
                FlexDirection(.column)
                AlignItems(.center)
                JustifyContent(.center)
                TextAlign(.center)
                Gap(12.px)
                Padding(vertical: 48.px, horizontal: 24.px)
            }
            Custom(".admin-status-view h1, .admin-status-view p") {
                Margin(0)
            }
            Custom(".admin-status-view .admin-status-view-icon") {
                Width(40.px)
                Height(40.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            if let icon {
                icon.class("admin-status-view-icon")
            }
            H1(state.title)
            P(state.message)
        }
        .class("admin-status-view")
    }
}
