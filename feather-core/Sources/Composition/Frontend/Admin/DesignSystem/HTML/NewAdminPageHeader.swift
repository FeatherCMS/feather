import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

/// Consistent heading and supporting description for new admin pages.
public struct NewAdminPageHeader: Component {
    public struct State: Sendable {
        public let title: String
        public let description: String
        public init(title: String, description: String) {
            self.title = title
            self.description = description
        }
    }

    public let state: State

    public init(state: State) { self.state = state }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-page-header") { Margin(bottom: 24.px) }
            Custom(".admin-page-header h1, .admin-page-header p") { Margin(0) }
            Custom(".admin-page-header p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Margin(top: 8.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            H1(state.title)
            P(state.description)
        }.class("admin-page-header")
    }
}
