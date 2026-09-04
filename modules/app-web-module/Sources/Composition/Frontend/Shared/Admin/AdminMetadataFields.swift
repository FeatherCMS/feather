import CSS
import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminMetadataFields: Leaf {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct CheckboxState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: Bool
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var slug: FieldState
        var template: FieldState
        var slugPrefix: String?
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

        mutating func apply(
            errors: [String: String]
        ) {
            slug.error = errors[slug.key]
            template.error = errors[template.key]
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
    var showTitle: Bool
    var showTemplate: Bool = false
    var titleRequired: Bool = false

    func selectors() -> [any CSS.Selector] {
        Class("admin-metadata-fields") {
            Display(.grid)
            Gap(20.px)
            MarginTop(32.px)
        }
        Class("admin-metadata-fields__group") {
            Display(.grid)
            Gap(18.px)
        }
        Class("admin-metadata-fields__section") {
            Display(.grid)
            Gap(18.px)
            BorderBottom(1.px, .solid, .variable("cms-gray-2"))
            PaddingBottom(20.px)
        }
        Custom(".admin-metadata-fields__section h3") {
            Margin(top: 0.px, right: 0.px, bottom: 4.px, left: 0.px)
            FontSize(18.px)
        }
        Class("admin-metadata-fields__prefixed-input") {
            Display(.flex)
            AlignItems(.center)
            Gap(12.px)
        }
        Class("admin-metadata-fields__prefix") {
            Color(.variable("cms-gray-7"))
            FontFamily(
                "ui-monospace",
                "SFMono-Regular",
                "Consolas",
                "'Liberation Mono'",
                "Menlo",
                "monospace",
            )
            FontSize(14.px)
            WhiteSpace(.nowrap)
        }
        Custom(".admin-metadata-fields__prefixed-input input") {
            Width(100.percent)
        }
        Custom(".admin-metadata-fields__group h3") {
            Margin(top: 0.px, right: 0.px, bottom: 4.px, left: 0.px)
            FontSize(18.px)
        }
        Custom(".admin-metadata-fields > section") {
            Margin(0.px)
        }
        Custom(".admin-metadata-fields__group > section") {
            Margin(0.px)
        }
        Custom(".admin-metadata-fields > section label") {
            Display(.grid)
            Gap(8.px)
        }
        Custom(".admin-metadata-fields__group > section label") {
            Display(.grid)
            Gap(8.px)
        }
    }

    func renderHTML() -> some BasicTag {
        Div {
            FormInputField(
                name: state.slug.key,
                label: state.slug.label,
                prefix: state.slugPrefix,
                value: state.slug.value,
                error: state.slug.error,
                isRequired: true
            ).renderHTML()
            if showTemplate {
                templateField(state.template).renderHTML()
            }

            Div {
                H3("Publishing")
                statusField(state.status).renderHTML()
                FormDateTimeField(
                    name: state.publicationDate.key,
                    label: state.publicationDate.label,
                    value: state.publicationDate.value,
                    error: state.publicationDate.error
                ).renderHTML()
                FormDateTimeField(
                    name: state.expirationDate.key,
                    label: state.expirationDate.label,
                    value: state.expirationDate.value,
                    error: state.expirationDate.error
                ).renderHTML()
            }
            .class("admin-metadata-fields__group")

            Div {
                H3("Social")
                Div {
                    if showTitle {
                        FormInputField(
                            name: state.title.key,
                            label: state.title.label,
                            value: state.title.value,
                            error: state.title.error,
                            isRequired: titleRequired
                        ).renderHTML()
                    }
                    textarea(state.excerpt, rows: 4).renderHTML()
                    imagePicker(
                        state.imageUrl,
                        selectedAsset: state.selectedImageAsset
                    )
                }
                .class("admin-metadata-fields__group")
            }
            .class("admin-metadata-fields__section")

            Div {
                H3("Advanced")
                Div {
                    FormInputField(
                        name: state.canonicalUrl.key,
                        label: state.canonicalUrl.label,
                        value: state.canonicalUrl.value,
                        error: state.canonicalUrl.error
                    ).renderHTML()
                    checkbox(state.noIndex)
                    FormInputField(
                        name: state.primaryKeyword.key,
                        label: state.primaryKeyword.label,
                        value: state.primaryKeyword.value,
                        error: state.primaryKeyword.error
                    ).renderHTML()
                    textarea(state.cssCodeInjection, rows: 10).renderHTML()
                    textarea(state.javascriptCodeInjection, rows: 10).renderHTML()
                    textarea(state.structuredDataCodeInjection, rows: 10).renderHTML()
                }
                .class("admin-metadata-fields__group")
            }
            .class("admin-metadata-fields__section")
        }
        .class("admin-metadata-fields")
    }

    private func statusField(
        _ field: FieldState
    ) -> FormSelectField {
        FormSelectField(
            name: field.key,
            label: field.label,
            options: ["draft", "published", "archived"]
                .map {
                    .init(label: $0.capitalized, value: $0)
                },
            selectedValue: field.value,
            error: field.error,
            isRequired: true
        )
    }

    private func templateField(
        _ field: FieldState
    ) -> FormSelectField {
        FormSelectField(
            name: field.key,
            label: field.label,
            options: [.init(label: "Default", value: "default")],
            selectedValue: field.value,
            error: field.error,
            isRequired: true
        )
    }

    private func imagePicker(
        _ field: FieldState,
        selectedAsset: AdminMediaAssetReferenceModel?
    ) -> Section {
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
        ).renderHTML()
    }

    private func textarea(
        _ field: FieldState,
        rows: Int
    ) -> FormTextAreaField {
        FormTextAreaField(
            name: field.key,
            label: field.label,
            value: field.value,
            error: field.error,
            rows: rows
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
            ).renderHTML()
        }
        .if(field.error != nil) { $0.class("has-error") }
    }
}
