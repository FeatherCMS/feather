import CSS
import HTML
import SGML
import WebStandards

struct WebMetadataForm: Component, FlowContent {

    struct FieldState: Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: Object {
        var referenceType: FieldState?
        var referenceId: FieldState?
        var slug: FieldState
        var publicationDate: FieldState
        var expirationDate: FieldState
        var status: FieldState
        var title: FieldState
        var excerpt: FieldState
        var imageUrl: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var canonicalUrl: FieldState
        var noIndex: CheckboxState
        var primaryKeyword: FieldState
        var cssCodeInjection: FieldState
        var javascriptCodeInjection: FieldState
        var structuredDataCodeInjection: FieldState
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            slug.error = errors[slug.key]
            publicationDate.error = errors[publicationDate.key]
            expirationDate.error = errors[expirationDate.key]
            status.error = errors[status.key]
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            imageUrl.error = errors[imageUrl.key]
            canonicalUrl.error = errors[canonicalUrl.key]
            noIndex.error = errors[noIndex.key]
            primaryKeyword.error = errors[primaryKeyword.key]
            cssCodeInjection.error = errors[cssCodeInjection.key]
            javascriptCodeInjection.error = errors[javascriptCodeInjection.key]
            structuredDataCodeInjection.error =
                errors[structuredDataCodeInjection.key]
        }
    }

    var state: State
    var action: String
    var submitLabel: String
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

            if let referenceType = state.referenceType {
                readonlyField(referenceType)
            }
            if let referenceId = state.referenceId {
                readonlyField(referenceId)
            }
            field(state.slug)
            field(state.publicationDate)
            field(state.expirationDate)
            statusField(state.status)
            field(state.title)
            textarea(state.excerpt, rows: 4)
            imagePicker(state.imageUrl, selectedAsset: state.selectedImageAsset)
            field(state.canonicalUrl)
            checkbox(state.noIndex)
            field(state.primaryKeyword)
            textarea(state.cssCodeInjection, rows: 10)
            textarea(state.javascriptCodeInjection, rows: 10)
            textarea(state.structuredDataCodeInjection, rows: 10)

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
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
                AdminFieldLabel(
                    label: field.label,
                    required:
                        field.key == "slug"
                        || field.key == "status"
                )
                Input()
                    .type(
                        field.key == "publicationDate"
                            || field.key == "expirationDate"
                            ? .datetimeLocal : .text
                    )
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

    private func readonlyField(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false)
                Input()
                    .type(.text)
                    .id(field.key)
                    .value(field.value)
                    .setAttribute(name: "readonly", value: "")
                    .setAttribute(name: "disabled", value: "")
            }
        }
    }

    private func statusField(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: true)
                Select {
                    for value in ["draft", "published", "archived"] {
                        if field.value == value {
                            Option(value.capitalized)
                                .value(value)
                                .selected()
                        }
                        else {
                            Option(value.capitalized)
                                .value(value)
                        }
                    }
                }
                .id(field.key)
                .name(field.key)
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func imagePicker(
        _ field: FieldState,
        selectedAsset: AdminMediaAssetReferenceModel?
    ) -> some FlowContent {
        let browsePath =
            "/admin/media/assets/?picker=1&field=\(field.key.queryEncoded())&extensions=png,jpg,jpeg,webp"
        return AdminMediaAssetPicker(
            state: .init(
                field: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                ),
                selectedAsset: selectedAsset,
                browsePath: browsePath,
                allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                outputMode: .originalURL
            )
        )
    }

    private func checkbox(
        _ field: CheckboxState
    ) -> some BasicTag {
        Section {
            CheckboxField(
                state: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                )
            )
        }
        .if(field.error != nil) { $0.class("has-error") }
    }

    private func textarea(
        _ field: FieldState,
        rows: Int
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false)
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
}
