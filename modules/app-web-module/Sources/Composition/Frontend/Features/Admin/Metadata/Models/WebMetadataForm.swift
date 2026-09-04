import CSS
import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebContracts
import WebComponents
import WebBuilders

struct WebMetadataForm: Leaf {

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
        var referenceType: FieldState?
        var referenceId: FieldState?
        var slug: FieldState
        var template: FieldState
        var templateOptions: [WebPageTemplateOption]
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
    var action: String
    var submitLabel: String
    var removeHref: String? = nil
    var removeLabel: String = "Remove"

    func html() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            FormInputField(
                name: state.slug.key,
                label: state.slug.label,
                value: state.slug.value,
                error: state.slug.error,
                isRequired: true
            ).html()
            templateField(state.template).html()
            FormDateTimeField(
                name: state.publicationDate.key,
                label: state.publicationDate.label,
                value: state.publicationDate.value,
                error: state.publicationDate.error
            ).html()
            FormDateTimeField(
                name: state.expirationDate.key,
                label: state.expirationDate.label,
                value: state.expirationDate.value,
                error: state.expirationDate.error
            ).html()
            statusField(state.status).html()
            FormInputField(
                name: state.title.key,
                label: state.title.label,
                value: state.title.value,
                error: state.title.error
            ).html()
            textarea(state.excerpt, rows: 4).html()
            imagePicker(state.imageUrl, selectedAsset: state.selectedImageAsset)
            FormInputField(
                name: state.canonicalUrl.key,
                label: state.canonicalUrl.label,
                value: state.canonicalUrl.value,
                error: state.canonicalUrl.error
            ).html()
            checkbox(state.noIndex)
            FormInputField(
                name: state.primaryKeyword.key,
                label: state.primaryKeyword.label,
                value: state.primaryKeyword.value,
                error: state.primaryKeyword.error
            ).html()
            textarea(state.cssCodeInjection, rows: 10).html()
            textarea(state.javascriptCodeInjection, rows: 10).html()
            textarea(state.structuredDataCodeInjection, rows: 10).html()

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                    if let removeHref {
                        AdminNavigationButton(
                            removeLabel,
                            href: removeHref,
                            classes: ["danger"]
                        ).html()
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

    private func readonlyField(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false).html()
                Input()
                    .type(.text)
                    .id(field.key)
                    .value(field.value)
                    .readOnly()
                    .disabled()
            }
        }
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
            options: [
                .init(label: "Default", value: "default")
            ] + fieldOptions(field),
            selectedValue: field.value,
            error: field.error,
            isRequired: true
        )
    }

    private func fieldOptions(
        _ field: FieldState
    ) -> [FormSelectField.Option] {
        state.templateOptions
            .map {
                .init(label: $0.title, value: $0.value)
            }
            .filter { $0.value != "default" }
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
        ).html()
    }

    private func checkbox(
        _ field: CheckboxState
    ) -> Section {
        Section {
            CheckboxField(
                state: .init(
                    key: field.key,
                    label: field.label,
                    value: field.value,
                    error: field.error
                )
            ).html()
        }
        .if(field.error != nil) { $0.class("has-error") }
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
}
