import CSS
import FeatherAdmin
import Foundation
import HTML
import SGML
import WebBuilders
import WebComponents

public struct WebPageRichContentEditor: Component {
    public struct State: Sendable {
        public let key: String
        public let label: String
        public let value: String?
        public let error: String?

        public init(
            key: String,
            label: String,
            value: String?,
            error: String?
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
        }
    }

    struct BlockDefinition: Sendable {
        let title: String
        let icon: String
        let type: String
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    private let blockDefinitions: [BlockDefinition] = [
        .init(title: "Heading", icon: "H", type: "heading"),
        .init(title: "Text", icon: "T", type: "text"),
        .init(title: "Image", icon: "▧", type: "image"),
        .init(title: "Video", icon: "▶", type: "video"),
        .init(title: "Unordered list", icon: "•", type: "ul"),
        .init(title: "Ordered list", icon: "1.", type: "ol"),
        .init(title: "Separator", icon: "—", type: "separator"),
        .init(title: "Grid", icon: "▦", type: "grid"),
        .init(title: "Blockquote", icon: "“", type: "blockquote"),
        .init(title: "Code block", icon: "{}", type: "code"),
        .init(title: "HTML", icon: "<>", type: "html"),
        .init(title: "Newsletter", icon: "✉", type: "newsletter"),
        .init(title: "Contact form", icon: "☏", type: "contact-form"),
        .init(title: "Custom block", icon: "✦", type: "custom"),
    ]

    public func rules() -> [any CSS.Rule] {
        let root = ".new-admin-web-page-rich-content-editor"

        let baseSelectors: [any CSS.Selector] = [
            Custom("\(root)") {
                Display(.flex)
                FlexDirection(.column)
                Gap(8.px)
                Width(100.percent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) > .new-admin-media-picker > label") {
                Display(.none)
            },
            Custom(
                "\(root) > .new-admin-media-picker > [data-media-picker-open]"
            ) {
                Display(.none)
            },
            Custom("\(root) *") {
                BoxSizing(.borderBox)
            },
            Custom("\(root) .workspace") {
                Display(.grid)
                Gap(18.px)
                AlignItems(.flexStart)
                Width(100.percent)
            },
            Custom("\(root) .panel") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
            },
            Custom("\(root) .sidebar") {
                Padding(vertical: 16.px, horizontal: 18.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .editor") {
                MinWidth(0.px)
                Overflow(.hidden)
            },
            Custom("\(root) .eyebrow") {
                Margin(bottom: 12.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.72.rem)
                FontWeight(.number(700))
                LetterSpacing(0.1.em)
                TextTransform(.uppercase)
            },
            Custom("\(root) .component-list") {
                Display(.grid)
                GridTemplateColumns(.repeat(6, .fraction(1.fr)))
                Gap(6.px)
            },
            Custom("\(root) .component-button") {
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.length(26.px), .fraction(1.fr)])
                )
                AlignItems(.center)
                Gap(6.px)
                MinWidth(0.px)
                MinHeight(38.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Padding(vertical: 6.px, horizontal: 8.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                TextAlign(.left)
                Cursor(.grab)
            },
            Custom("\(root) .component-button:hover") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .component-button:active") {
                Cursor(.grabbing)
            },
            Custom("\(root) .component-button small") {
                Display(.none)
            },
            Custom("\(root) .component-icon") {
                Display(.grid)
                AlignItems(.center)
                JustifyContent(.center)
                Width(26.px)
                Height(26.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
                FontSize(0.75.rem)
                FontWeight(.number(800))
                LineHeight(1)
            },
            Custom("\(root) .sidebar-footer") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(16.px)
                BorderTop(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Margin(top: 14.px)
                Padding(top: 10.px)
            },
            Custom("\(root) .hint") {
                Margin(0)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.78.rem)
            },
            Custom("\(root) .insert-toggle") {
                Display(.flex)
                AlignItems(.center)
                Gap(9.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.78.rem)
            },
            Custom("\(root) .insert-toggle strong") {
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .insert-options") {
                Display(.flex)
            },
            Custom("\(root) .insert-options button") {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Padding(vertical: 5.px, horizontal: 9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .insert-options button.active") {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
                FontWeight(.number(700))
            },
            Custom("\(root) .editor-bar") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(12.px)
                BorderBottom(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                Padding(vertical: 13.px, horizontal: 18.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.82.rem)
            },
            Custom("\(root) .mode-switch") {
                Display(.flex)
                Gap(3.px)
                Padding(3.px)
                BorderRadius(8.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .mode-switch button") {
                Border(0)
                BorderRadius(6.px)
                Padding(vertical: 5.px, horizontal: 10.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.75.rem)
                Cursor(.pointer)
            },
            Custom("\(root) .mode-switch button.active") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .status") {
                Color(.variable(TokenKey.Colors.Link.default))
                FontWeight(.number(600))
            },
            Custom("\(root) .visual-canvas") {
                MinHeight(560.px)
                Padding(13.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom("\(root) .visual-canvas.drag-over") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .visual-canvas > .block") {
                Margin(top: 6.px)
            },
            Custom("\(root) .block") {
                Position(.relative)
                Display(.grid)
                GridTemplateColumns(
                    .tracks([.length(25.px), .fraction(1.fr), .auto])
                )
                Gap(10.px)
                AlignItems(.flexStart)
                Border(1.px, .solid, .transparent)
                BorderRadius(9.px)
                Padding(vertical: 12.px, horizontal: 8.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .block:hover, \(root) .block.dragging") {
                BorderColor(.variable(TokenKey.Colors.Materials.Primary.border))
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .drag-controls") {
                Display(.grid)
                Gap(3.px)
            },
            Custom("\(root) .drag-handle") {
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(1.1.rem)
                Cursor(.grab)
                UserSelect(.none)
            },
            Custom("\(root) .move-button, \(root) .remove") {
                Border(0)
                BorderRadius(6.px)
                Padding(3.px)
                Background(.transparent)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                Cursor(.pointer)
            },
            Custom("\(root) .move-button:hover, \(root) .remove:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom("\(root) .block-body") {
                MinWidth(0.px)
            },
            Custom("\(root) .block-label") {
                Display(.block)
                Margin(bottom: 5.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                FontSize(0.65.rem)
                FontWeight(.number(700))
                LetterSpacing(0.08.em)
                TextTransform(.uppercase)
            },
            Custom("\(root) .block input, \(root) .block textarea") {
                Width(100.percent)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(9.px)
                Padding(vertical: 9.px, horizontal: 11.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Outline(0)
            },
            Custom("\(root) .block textarea") {
                UnsafeRawProperty(name: "min-height", value: "12lh")
                Resize(.none)
            },
            Custom(
                "\(root) .block input:focus, \(root) .block textarea:focus, \(root) #markdownInput:focus"
            ) {
                BorderColor(
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BoxShadow(.none)
                Outline(
                    2.px,
                    .solid,
                    .color(.variable(TokenKey.Colors.Link.hover))
                )
                OutlineOffset(2.px)
            },
            Custom("\(root) .format-toolbar, \(root) .heading-toolbar") {
                Display(.flex)
                Gap(4.px)
                Margin(bottom: 6.px)
            },
            Custom(
                "\(root) .format-toolbar button, \(root) .heading-toolbar button"
            ) {
                MinWidth(29.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Padding(vertical: 4.px, horizontal: 7.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                Cursor(.pointer)
            },
            Custom(
                "\(root) .format-toolbar button:hover, \(root) .heading-toolbar button:hover, \(root) .heading-toolbar button.active"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom(
                "\(root) .media-picker-button, \(root) .embed-picker-button"
            ) {
                Display(.inlineFlex)
                AlignItems(.center)
                JustifyContent(.center)
                BoxSizing(.borderBox)
                UnsafeRawProperty(name: "font", value: "inherit")
                FontWeight(.normal)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.border)
                )
                BorderRadius(6.px)
                Padding(vertical: 7.px, horizontal: 10.px)
                Background(
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.tint)
                )
                Color(.variable(TokenKey.Colors.Buttons.Ghost.Primary.text))
                Cursor(.pointer)
                TextDecoration(.none)
            },
            Custom(
                "\(root) .media-picker-button:hover, \(root) .embed-picker-button:hover"
            ) {
                Background(
                    .variable(TokenKey.Colors.Buttons.Ghost.Primary.hover)
                )
            },
            Custom("\(root) #rawView") {
                Padding(18.px)
            },
            Custom("\(root) #markdownInput") {
                Display(.block)
                Width(100.percent)
                UnsafeRawProperty(name: "min-height", value: "12lh")
                Resize(.none)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                Padding(17.px)
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                Outline(0)
                UnsafeRawProperty(
                    name: "font",
                    value:
                        "14px/1.7 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace"
                )
            },
            Custom("\(root) #previewView") {
                MinHeight(560.px)
                Padding(vertical: 42.px, horizontal: 7.percent)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom("\(root) .preview-content") {
                MaxWidth(760.px)
                MarginLeft(.auto)
                MarginRight(.auto)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom(
                "\(root) .preview-content h1, \(root) .preview-content h2, \(root) .preview-content h3, \(root) .preview-content h4, \(root) .preview-content h5, \(root) .preview-content h6"
            ) {
                Margin(bottom: 12.px)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom(
                "\(root) .preview-content p, \(root) .preview-content ul, \(root) .preview-content ol, \(root) .preview-content blockquote, \(root) .preview-content pre"
            ) {
                Margin(bottom: 22.px)
            },
            Custom("\(root) .preview-content a") {
                Color(.variable(TokenKey.Colors.Link.default))
            },
            Custom(
                "\(root) .preview-content img, \(root) .preview-content video"
            ) {
                Display(.block)
                MaxWidth(100.percent)
                Margin(top: 8.px, bottom: 22.px)
                BorderRadius(9.px)
            },
            Custom("\(root) .preview-content pre") {
                OverflowX(.auto)
                Padding(16.px)
                BorderRadius(9.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Secondary.text))
            },
            Custom("\(root) .preview-empty, \(root) .empty") {
                Padding(vertical: 105.px, horizontal: 20.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                TextAlign(.center)
            },
            Custom(
                "\(root) .media-fields, \(root) .embed-fields, \(root) .custom-fields, \(root) .quote-fields, \(root) .grid-settings"
            ) {
                Display(.grid)
                Gap(8.px)
            },
            Custom("\(root) .grid-columns") {
                Display(.grid)
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                Gap(8.px)
            },
            Custom("\(root) .grid-column, \(root) .grid-child") {
                MinWidth(0.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
                Padding(8.px)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
            },
            Custom(
                "\(root) .grid-column.drop-target, \(root) .grid-child.drop-target"
            ) {
                BorderColor(.variable(TokenKey.Colors.Link.default))
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
            },
            Custom("\(root) .grid-column-empty") {
                MinHeight(82.px)
                Display(.grid)
                AlignItems(.center)
                JustifyContent(.center)
                Border(
                    1.px,
                    .dashed,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(6.px)
                Padding(10.px)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                TextAlign(.center)
            },
            Custom("\(root) .drop-marker") {
                Height(4.px)
                Margin(vertical: 5.px, horizontal: 4.px)
                BorderRadius(5.px)
                Background(.variable(TokenKey.Colors.Link.default))
                Opacity(0)
                PointerEvents(.none)
            },
            Custom("\(root) .drop-marker.visible") {
                Opacity(1)
            },
            Custom("\(root) .mce-embed-picker") {
                Position(.fixed)
                Top(0.px)
                Right(0.px)
                Bottom(0.px)
                Left(0.px)
                ZIndex(.number(20))
                Display(.none)
                AlignItems(.center)
                JustifyContent(.center)
                Padding(24.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .mce-embed-picker.is-visible") {
                Display(.flex)
            },
            Custom("\(root) .mce-embed-picker-dialog") {
                Width(90.percent)
                MaxWidth(720.px)
                MaxHeight(90.vh)
                Overflow(.auto)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(12.px)
                Padding(18.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            },
            Custom(
                "\(root) .mce-embed-picker-header, \(root) .mce-embed-picker-search"
            ) {
                Display(.flex)
                AlignItems(.center)
                Gap(8.px)
            },
            Custom("\(root) .mce-embed-picker-header") {
                JustifyContent(.spaceBetween)
                Margin(bottom: 14.px)
            },
            Custom("\(root) .mce-embed-picker-search") {
                Margin(bottom: 12.px)
            },
            Custom("\(root) .mce-embed-picker-search input") {
                MinWidth(0.px)
                FlexGrow(1)
            },
            Custom(
                "\(root) .mce-embed-picker-search input, \(root) .mce-embed-picker-search button, \(root) .mce-embed-picker-list button"
            ) {
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(7.px)
                Padding(vertical: 8.px, horizontal: 9.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            },
            Custom("\(root) .mce-embed-picker-list") {
                Display(.grid)
                Gap(7.px)
            },
            Custom("\(root) .mce-embed-picker-list button") {
                TextAlign(.left)
                Cursor(.pointer)
            },
        ]

        return [
            Media {
                for selector in baseSelectors {
                    selector
                }
            },
            Media(.maxWidth(900.px)) {
                Custom("\(root) .component-list") {
                    GridTemplateColumns(.repeat(3, .fraction(1.fr)))
                }
                Custom("\(root) .grid-columns") {
                    GridTemplateColumns(.repeat(2, .fraction(1.fr)))
                }
            },
            Media(.maxWidth(600.px)) {
                Custom("\(root) .component-list") {
                    GridTemplateColumns(.repeat(2, .fraction(1.fr)))
                }
                Custom("\(root) .grid-columns") {
                    GridTemplateColumns(.fraction(1.fr))
                }
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        Section {
            context.build(NewAdminFormFieldLabel(text: state.label))
            Div {
                Div {
                    P("Add component").class("eyebrow")
                    Div {
                        for definition in blockDefinitions {
                            Button {
                                Span(definition.icon)
                                    .class("component-icon")
                                    .setAttribute(
                                        name: "aria-hidden",
                                        value: "true"
                                    )
                                Span(definition.title)
                                Small(definition.title)
                            }
                            .type(.button)
                            .class("component-button")
                            .setAttribute(
                                name: "data-add",
                                value: definition.type
                            )
                        }
                    }
                    .class("component-list")
                    Div {
                        P(
                            "Drag the handle to rearrange blocks. Select text inside a text block to format it."
                        )
                        .class("hint")
                        Div {
                            Strong("Insert at")
                            Div {
                                Button("Bottom")
                                    .type(.button)
                                    .class("active")
                                    .setAttribute(
                                        name: "data-insert",
                                        value: "bottom"
                                    )
                                Button("Top")
                                    .type(.button)
                                    .setAttribute(
                                        name: "data-insert",
                                        value: "top"
                                    )
                            }
                            .class("insert-options")
                        }
                        .class("insert-toggle")
                    }
                    .class("sidebar-footer")
                }
                .class("panel", "sidebar")
                Div {
                    Div {
                        Nav {
                            Button("Visual")
                                .type(.button)
                                .class("active")
                                .setAttribute(
                                    name: "data-mode",
                                    value: "visual"
                                )
                            Button("Markdown")
                                .type(.button)
                                .setAttribute(
                                    name: "data-mode",
                                    value: "raw"
                                )
                            Button("Preview")
                                .type(.button)
                                .setAttribute(
                                    name: "data-mode",
                                    value: "preview"
                                )
                        }
                        .class("mode-switch")
                        Span("Ready").id("status").class("status")
                    }
                    .class("editor-bar")
                    Div {
                        Div {}
                            .id("canvas")
                            .class("visual-canvas")
                    }
                    .id("visualView")
                    Div {
                        Div {}.id("previewContent").class("preview-content")
                    }
                    .id("previewView")
                    .hidden()
                    Div {
                        Textarea(state.value ?? "")
                            .id("markdownInput")
                            .name(state.key)
                            .rows(12)
                            .setAttribute(name: "spellcheck", value: "false")
                            .setAttribute(
                                name: "data-media-base-url",
                                value: AppEnvironmentStore.current.publicOrigins
                                    .mediaBaseURL.absoluteString
                            )
                            .class("markdown-source")
                    }
                    .id("rawView")
                    .hidden()
                }
                .class("panel", "editor")
            }
            .class(
                "workspace",
                "mce-app",
                "new-admin-web-page-rich-content-editor"
            )
            .data("markdown-image-picker", "markdown-image-url")
            .data("markdown-video-picker", "markdown-video-url")
            .data(
                "markdown-media-base-url",
                AppEnvironmentStore.current.publicOrigins.mediaBaseURL
                    .absoluteString
            )
            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-image-url",
                            label: "Choose image",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-image-url&extensions=png,jpg,jpeg,webp,gif",
                        allowedExtensions: [
                            "png", "jpg", "jpeg", "webp", "gif",
                        ],
                        outputMode: .relativeURL,
                        showsCurrentCard: false
                    )
                )
            )
            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: "markdown-video-url",
                            label: "Choose video",
                            value: nil,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=markdown-video-url&extensions=mp4,mov,webm",
                        allowedExtensions: ["mp4", "mov", "webm"],
                        outputMode: .relativeURL,
                        showsCurrentCard: false
                    )
                )
            )
            if let error = state.error {
                Span(error).class("field-error")
            }
            Script()
                .src(
                    "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/admin/markdown-editor.js"
                )
                .defer()
        }
        .if(state.error != nil) { $0.class("has-error") }
        .class("new-admin-web-page-rich-content-editor")
    }
}
