import FeatherAdmin
import Foundation
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebMetadataForm: Component {

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

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let success = state.success {
                P(success).class("new-admin-form__success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }

            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.slug.key,
                        label: state.slug.label,
                        value: state.slug.value,
                        error: state.slug.error,
                        isRequired: true
                    )
                )
            )
            context.render(templateField(state.template))
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.publicationDate.key,
                        label: state.publicationDate.label,
                        value: state.publicationDate.value,
                        error: state.publicationDate.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.expirationDate.key,
                        label: state.expirationDate.label,
                        value: state.expirationDate.value,
                        error: state.expirationDate.error
                    )
                )
            )
            context.render(statusField(state.status))
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.title.key,
                        label: state.title.label,
                        value: state.title.value,
                        error: state.title.error
                    )
                )
            )
            context.render(textarea(state.excerpt, rows: 4))
            imagePicker(
                state.imageUrl,
                selectedAsset: state.selectedImageAsset,
                context: &context
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.canonicalUrl.key,
                        label: state.canonicalUrl.label,
                        value: state.canonicalUrl.value,
                        error: state.canonicalUrl.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldCheckbox(
                    state: .init(
                        name: state.noIndex.key,
                        label: state.noIndex.label,
                        isChecked: state.noIndex.value,
                        error: state.noIndex.error
                    )
                )
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.primaryKeyword.key,
                        label: state.primaryKeyword.label,
                        value: state.primaryKeyword.value,
                        error: state.primaryKeyword.error
                    )
                )
            )
            context.render(textarea(state.cssCodeInjection, rows: 10))
            context.render(textarea(state.javascriptCodeInjection, rows: 10))
            context.render(
                textarea(state.structuredDataCodeInjection, rows: 10)
            )

            Section {
                Div {
                    context.render(NewAdminSubmitButton(submitLabel))
                    if let removeHref {
                        context.render(
                            NewAdminButton(
                                removeLabel,
                                href: removeHref,
                                style: .destructive
                            )
                        )
                    }
                }
                .class("new-admin-form__actions")
            }
        }
        context.register(form)
        return form.html(context: &context)
    }

    private func readonlyField(
        _ field: FieldState,
        context: inout RenderContext
    ) -> some BasicTag {

        Section {
            Label {
                Label(field.label).class("new-admin-form-field-label")
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
    ) -> NewAdminFormFieldSelect {
        NewAdminFormFieldSelect(
            state: .init(
                name: field.key,
                label: field.label,
                value: field.value,
                options: ["draft", "published", "archived"]
                    .map {
                        .init(label: $0.capitalized, value: $0)
                    },
                error: field.error,
                isRequired: true
            )
        )
    }

    private func templateField(
        _ field: FieldState
    ) -> NewAdminFormFieldSelect {
        NewAdminFormFieldSelect(
            state: .init(
                name: field.key,
                label: field.label,
                value: field.value,
                options: [
                    .init(label: "Default", value: "default")
                ] + fieldOptions(field),
                error: field.error,
                isRequired: true
            )
        )
    }

    private func fieldOptions(
        _ field: FieldState
    ) -> [NewAdminFormFieldSelect.SelectOption] {
        state.templateOptions
            .map {
                .init(label: $0.title, value: $0.value)
            }
            .filter { $0.value != "default" }
    }

    private func imagePicker(
        _ field: FieldState,
        selectedAsset: AdminMediaAssetReferenceModel?,
        context: inout RenderContext
    ) -> Section {

        let browsePath =
            "/admin/media/assets/?picker=1&field=\(field.key.queryEncoded())&extensions=png,jpg,jpeg,webp"
        return context.render(
            AdminMediaAssetPicker(
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
        )
    }

    private func textarea(
        _ field: FieldState,
        rows: Int
    ) -> NewAdminFormFieldTextArea {
        NewAdminFormFieldTextArea(
            state: .init(
                name: field.key,
                label: field.label,
                value: field.value,
                error: field.error,
                style: rows <= 4 ? .small : .large
            )
        )
    }
}
