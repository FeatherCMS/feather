import CSS
import HTML
import SGML
import WebStandards

struct WebPageForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: Object {
        var title: FieldState
        var excerpt: FieldState
        var content: FieldState
        var imageAssetId: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var metadata: AdminMetadataFields.State
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            content.error = errors[content.key]
            imageAssetId.error = errors[imageAssetId.key]
            metadata.apply(errors: errors)
        }
    }

    var state: State
    var action: String
    var submitLabel: String
    var publishLabel: String? = nil
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            AdminMediaAssetPicker(
                state: .init(
                    field: .init(
                        key: state.imageAssetId.key,
                        label: state.imageAssetId.label,
                        value: state.imageAssetId.value,
                        error: state.imageAssetId.error
                    ),
                    selectedAsset: state.selectedImageAsset,
                    browsePath:
                        "/admin/media/assets/?picker=1&field=\(state.imageAssetId.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                    allowedExtensions: ["png", "jpg", "jpeg", "webp"]
                )
            )
            field(state.title)
            textarea(state.excerpt, required: false, rows: 4)
            markdownEditor(state.content)
            AdminMetadataFields(
                state: state.metadata,
                showTitle: true,
                titleRequired: false
            )

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let publishLabel {
                        Button(publishLabel)
                            .type(.submit)
                            .name("submitAction")
                            .value("publish")
                            .class("secondary")
                    }
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        )
                    }
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }

    private func field(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: true)
                Input()
                    .type(.text)
                    .id(field.key)
                    .name(field.key)
                    .value(field.value)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func textarea(
        _ field: FieldState,
        required: Bool = true,
        rows: Int = 12
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: required)
                Textarea(field.value ?? "")
                    .id(field.key)
                    .name(field.key)
                    .rows(rows)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func markdownEditor(
        _ field: FieldState
    ) -> some FlowContent {
        Section {
            AdminFieldLabel(label: field.label, required: true)
            Link(rel: .stylesheet).href(
                "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/admin-markdown-editor.css"
            )
            Div {
                Div {
                    P("Add component").class("eyebrow")
                    Div {
                        for (title, icon, type) in [
                            ("Heading", "H", "heading"), ("Text", "T", "text"),
                            ("Image", "▧", "image"), ("Video", "▶", "video"),
                            ("Unordered list", "•", "ul"), ("Ordered list", "1.", "ol"),
                            ("Separator", "—", "separator"), ("Blockquote", "“", "blockquote"),
                            ("Code block", "</>", "code"), ("HTML", "<>", "html"),
                            ("Grid", "▦", "grid"), ("Custom block", "✦", "custom")
                        ] {
                            Button {
                                Span(icon).class("component-icon").setAttribute(name: "aria-hidden", value: "true")
                                Span(title)
                                Small(title)
                            }
                            .type(.button)
                            .class("component-button")
                            .setAttribute(name: "data-add", value: type)
                        }
                    }.class("component-list")
                    Div {
                        P("Drag the handle to rearrange blocks. Select text inside a text block to format it.").class("hint")
                        Div {
                            Strong("Insert at")
                            Div {
                                Button("Bottom").type(.button).class("active").setAttribute(name: "data-insert", value: "bottom")
                                Button("Top").type(.button).setAttribute(name: "data-insert", value: "top")
                            }.class("insert-options")
                        }.class("insert-toggle")
                    }.class("sidebar-footer")
                }.class("panel sidebar")
                Div {
                    Div {
                        Nav {
                            Button("Visual").type(.button).class("active").setAttribute(name: "data-mode", value: "visual")
                            Button("Preview").type(.button).setAttribute(name: "data-mode", value: "preview")
                            Button("Markdown").type(.button).setAttribute(name: "data-mode", value: "raw")
                        }.class("mode-switch")
                        Span("Ready").id("status").class("status")
                    }.class("editor-bar")
                    Div {
                        Div {}.id("canvas").class("visual-canvas")
                    }.id("visualView")
                    Div {
                        Div {}.id("previewContent").class("preview-content")
                    }.id("previewView").hidden()
                    Div {
                        Textarea(field.value ?? "")
                            .id("markdownInput")
                            .name(field.key)
                            .rows(12)
                            .setAttribute(name: "spellcheck", value: "false")
                            .setAttribute(
                                name: "data-media-base-url",
                                value: AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString
                            )
                            .class("markdown-source")
                    }.id("rawView").hidden()
                }.class("panel editor")
            }
            .class("workspace", "mce-app")
            .data("markdown-image-picker", "markdown-image-url")
            .data("markdown-video-picker", "markdown-video-url")
            .data(
                "markdown-media-base-url",
                AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString
            )
            AdminMediaAssetPicker(
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
                    allowedExtensions: ["png", "jpg", "jpeg", "webp", "gif"],
                    outputMode: .relativeURL,
                    showsCurrentCard: false
                )
            )
            AdminMediaAssetPicker(
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
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }
}
