public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

/// Consistent heading and supporting description for new admin pages.
public struct NewAdminPageHeader: Component {
    public struct State: Sendable {
        public let title: String
        public let description: String
        public let preview: NewAdminButton.State?
        public let level: Int
        public let showSeparator: Bool

        private init(
            title: String,
            description: String,
            preview: NewAdminButton.State?,
            level: Int,
            showSeparator: Bool
        ) {
            self.title = title
            self.description = description
            self.preview = preview
            self.level = min(max(level, 1), 6)
            self.showSeparator = showSeparator
        }

        public static func primary(
            title: String,
            description: String,
            preview: NewAdminButton.State? = nil
        ) -> Self {
            .init(
                title: title,
                description: description,
                preview: preview,
                level: 1,
                showSeparator: false
            )
        }

        public static func secondary(
            title: String,
            description: String
        ) -> Self {
            .init(
                title: title,
                description: description,
                preview: nil,
                level: 2,
                showSeparator: true
            )
        }
    }

    public let state: State

    public init(state: State) { self.state = state }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-page-header") { Margin(bottom: 24.px) }
            Custom(
                ".admin-page-header h1, .admin-page-header h2, "
                    + ".admin-page-header h3, .admin-page-header h4, "
                    + ".admin-page-header h5, .admin-page-header h6, "
                    + ".admin-page-header p"
            ) { Margin(0) }
            Custom(
                ".admin-page-header h1, .admin-page-header h2, "
                    + ".admin-page-header h3, .admin-page-header h4, "
                    + ".admin-page-header h5, .admin-page-header h6"
            ) {
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
            Custom(".admin-page-header__separator") {
                Border(0)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Margin(top: 16.px, bottom: 0.px)
            }
        }
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            for heading in heading() { heading }
            P(state.description)
            if state.showSeparator {
                Hr().class("admin-page-header__separator")
            }
        }
        .class("admin-page-header")
    }

    private func heading() -> [any FlowContent] {
        switch state.level {
        case 2: [H2 { headingContents() }]
        case 3: [H3 { headingContents() }]
        case 4: [H4 { headingContents() }]
        case 5: [H5 { headingContents() }]
        case 6: [H6 { headingContents() }]
        default: [H1 { headingContents() }]
        }
    }

    private func headingContents() -> [any PhrasingContent] {
        var contents: [any PhrasingContent] = [Span(state.title)]
        if let preview = state.preview, let previewHref = preview.href {
            contents.append(
                A { FeatherIcons.externalLink() }
                    .href(previewHref)
                    .target(.blank)
                    .ariaLabel(preview.label)
                    .class("admin-page-header__preview-link")
            )
        }
        return contents
    }
}
