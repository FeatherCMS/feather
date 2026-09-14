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
        public let previewHref: String?
        public let previewLabel: String

        public init(
            title: String,
            description: String,
            previewHref: String? = nil,
            previewLabel: String = "Preview"
        ) {
            self.title = title
            self.description = description
            self.previewHref = previewHref
            self.previewLabel = previewLabel
        }
    }

    public let state: State

    public init(state: State) { self.state = state }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-page-header") { Margin(bottom: 24.px) }
            Custom(".admin-page-header h1, .admin-page-header p") { Margin(0) }
            Custom(".admin-page-header h1") {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            }
            Custom(".admin-page-header__preview-link") {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(1.25.rem)
                Height(1.25.rem)
                Color(.variable(TokenKey.Colors.Link.default))
            }
            Custom(".admin-page-header p") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Margin(top: 8.px)
            }
        }
    }

    public func html(context: inout RenderContext) -> Div {
        Div {
            H1 {
                Span(state.title)
                if let previewHref = state.previewHref {
                    A { FeatherIcons.externalLink() }
                        .href(previewHref)
                        .target(.blank)
                        .ariaLabel(state.previewLabel)
                        .class("admin-page-header__preview-link")
                }
            }
            P(state.description)
        }
        .class("admin-page-header")
    }
}
