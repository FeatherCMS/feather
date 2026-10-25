public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

/// Consistent heading and supporting description for new admin pages.
public struct AdminPageHeader: Component {
    public struct State: Sendable {
        public let title: String
        public let description: String
        public let preview: AdminButton.State?
        public let moreActions: [AdminButton.State]
        public let level: Int
        public let showSeparator: Bool

        private init(
            title: String,
            description: String,
            preview: AdminButton.State?,
            moreActions: [AdminButton.State],
            level: Int,
            showSeparator: Bool
        ) {
            self.title = title
            self.description = description
            self.preview = preview
            self.moreActions = moreActions
            self.level = min(max(level, 1), 6)
            self.showSeparator = showSeparator
        }

        public static func primary(
            title: String,
            description: String,
            preview: AdminButton.State? = nil,
            moreActions: [AdminButton.State] = []
        ) -> Self {
            .init(
                title: title,
                description: description,
                preview: preview,
                moreActions: moreActions,
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
                moreActions: [],
                level: 2,
                showSeparator: true
            )
        }

        public func addingMoreActions(_ additionalActions: [AdminButton.State])
            -> Self
        {
            .init(
                title: title,
                description: description,
                preview: preview,
                moreActions: moreActions + additionalActions,
                level: level,
                showSeparator: showSeparator
            )
        }
    }

    public let state: State

    public init(state: State) { self.state = state }

    public func rules() -> [any Rule] {
        Media {
            Custom(".admin-page-header") {
                Display(.flex)
                AlignItems(.flexStart)
                JustifyContent(.spaceBetween)
                Gap(16.px)
                Margin(bottom: 24.px)
            }
            Custom(".admin-page-header__content") {
                Flex(1)
                MinWidth(0.px)
            }
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
            Custom(".admin-page-header__actions") {
                Position(.relative)
                FlexShrink(0)
            }
            Custom(".admin-page-header__actions-trigger") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.center)
                Width(38.px)
                Height(38.px)
                Padding(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BorderRadius(999.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Cursor(.pointer)
                ListStyle(.none)
            }
            Custom(
                ".admin-page-header__actions-trigger::-webkit-details-marker"
            ) {
                Display(.none)
            }
            Custom(".admin-page-header__actions-trigger:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            }
            Custom(".admin-page-header__actions-menu") {
                Position(.absolute)
                Right(0.px)
                Top(44.px)
                MinWidth(180.px)
                ListStyle(.none)
                Padding(vertical: 6.px, horizontal: 0.px)
                Margin(0)
                ZIndex(.number(20))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(10.px)
                BoxShadow(
                    0.px,
                    10.px,
                    blur: 24.px,
                    color: CSSColor(
                        stringLiteral:
                            "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))"
                    )
                )
            }
            Custom(".admin-page-header__actions-menu li .button") {
                Display(.block)
                Width(100.percent)
                BoxSizing(.borderBox)
                Padding(vertical: 9.px, horizontal: 12.px)
                Border(0)
                BorderRadius(0.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                TextAlign(.left)
                TextDecoration(.none)
                BoxShadow(.none)
            }
            Custom(".admin-page-header__actions-menu li .button.destructive") {
                Color(.red)
            }
            Custom(
                ".admin-page-header__actions-menu .button:hover:not(:disabled):not(.disabled)"
            ) {
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            }
            Custom(
                ".admin-page-header__actions[open] .admin-page-header__actions-menu"
            ) {
                Display(.block)
            }
        }
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            Div {
                for heading in heading() { heading }
                P(state.description)
                if state.showSeparator {
                    Hr().class("admin-page-header__separator")
                }
            }
            .class("admin-page-header__content")
            if !state.moreActions.isEmpty {
                Details {
                    Summary {
                        if let icon = FeatherIcons.get(named: "moreHorizontal")
                        {
                            icon
                        }
                    }
                    .class("admin-page-header__actions-trigger")
                    .ariaLabel("More actions")
                    Ul {
                        for action in state.moreActions {
                            Li {
                                context.build(AdminButton(state: action))
                            }
                        }
                    }
                    .class("admin-page-header__actions-menu")
                }
                .class("admin-page-header__actions")
            }
        }
        .class("admin-page-header")
    }

    public func scripts() -> [String] {
        guard !state.moreActions.isEmpty else { return [] }

        return [
            #"""
            (function () {
                var root = document.documentElement;
                if (root.dataset.adminPageHeaderMenuListener === "1") {
                    return;
                }
                root.dataset.adminPageHeaderMenuListener = "1";

                document.addEventListener("click", function (event) {
                    document.querySelectorAll(
                        ".admin-page-header__actions[open]"
                    ).forEach(function (menu) {
                        var actionItems = menu.querySelector(
                            ".admin-page-header__actions-menu"
                        );
                        if (
                            !menu.contains(event.target) ||
                            (actionItems && actionItems.contains(event.target))
                        ) {
                            menu.removeAttribute("open");
                        }
                    });
                });
            })();
            """#
        ]
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
