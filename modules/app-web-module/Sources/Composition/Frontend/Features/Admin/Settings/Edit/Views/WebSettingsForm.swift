import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebSettingsForm: Component {

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

    struct HomePageState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var options: [NewAdminFormFieldSelectAutocomplete.Option]
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var logo: FieldState
        var logoDark: FieldState
        var metaImage: FieldState
        var primaryColor: FieldState
        var secondaryColor: FieldState
        var tertiaryColor: FieldState
        var primaryFont: FieldState
        var secondaryFont: FieldState
        var homePage: HomePageState
        var locale: FieldState
        var timezone: FieldState
        var title: FieldState
        var excerpt: FieldState
        var noIndex: CheckboxState
        var css: FieldState
        var js: FieldState
        var canEdit: Bool
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            logo.error = errors[logo.key]
            logoDark.error = errors[logoDark.key]
            metaImage.error = errors[metaImage.key]
            primaryColor.error = errors[primaryColor.key]
            secondaryColor.error = errors[secondaryColor.key]
            tertiaryColor.error = errors[tertiaryColor.key]
            primaryFont.error = errors[primaryFont.key]
            secondaryFont.error = errors[secondaryFont.key]
            homePage.error = errors[homePage.key]
            locale.error = errors[locale.key]
            timezone.error = errors[timezone.key]
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            noIndex.error = errors[noIndex.key]
            css.error = errors[css.key]
            js.error = errors[js.key]
        }
    }

    var state: State
    var action: String = "/admin/web/settings/"
    var submitLabel: String = "Save settings"

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let success = state.success {
                P(success).class("new-admin-form__success")
            }
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }

            context.render(
                NewAdminFormGroup(
                    id: "web-settings-branding",
                    title: "Branding",
                    persistsState: false
                ) {
                    imagePicker(state.logo, context: &context)
                    imagePicker(state.logoDark, context: &context)
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "web-settings-seo",
                    title: "SEO",
                    persistsState: false
                ) {
                    context.render(
                        NewAdminFormFieldCheckbox(
                            state: .init(
                                name: state.noIndex.key,
                                label: "Search engine indexing",
                                checkboxLabel: "Disallow site indexing",
                                isChecked: state.noIndex.value,
                                error: state.noIndex.error
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.title.key,
                                label: state.title.label,
                                value: state.title.value,
                                error: state.title.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(textarea(state.excerpt, rows: 4))
                    imagePicker(state.metaImage, context: &context)
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "web-settings-site-defaults",
                    title: "Site defaults",
                    persistsState: false
                ) {
                    homePagePicker(state.homePage, context: &context)
                    context.render(
                        NewAdminFormFieldLanguage(
                            state: .init(
                                name: state.locale.key,
                                label: state.locale.label,
                                value: state.locale.value,
                                error: state.locale.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldTimezone(
                            state: .init(
                                name: state.timezone.key,
                                label: state.timezone.label,
                                value: state.timezone.value,
                                error: state.timezone.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "web-settings-theme",
                    title: "Theme",
                    persistsState: false
                ) {
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.primaryColor.key,
                                label: state.primaryColor.label,
                                value: state.primaryColor.value,
                                error: state.primaryColor.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.secondaryColor.key,
                                label: state.secondaryColor.label,
                                value: state.secondaryColor.value,
                                error: state.secondaryColor.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.tertiaryColor.key,
                                label: state.tertiaryColor.label,
                                value: state.tertiaryColor.value,
                                error: state.tertiaryColor.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.primaryFont.key,
                                label: state.primaryFont.label,
                                value: state.primaryFont.value,
                                error: state.primaryFont.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: state.secondaryFont.key,
                                label: state.secondaryFont.label,
                                value: state.secondaryFont.value,
                                error: state.secondaryFont.error,
                                isDisabled: !state.canEdit
                            )
                        )
                    )
                }
            )

            context.render(
                NewAdminFormGroup(
                    id: "web-settings-code-injection",
                    title: "Code injection",
                    persistsState: false
                ) {
                    context.render(textarea(state.css, rows: 10))
                    context.render(textarea(state.js, rows: 10))
                }
            )

            if state.canEdit {
                Div {
                    Div {
                        context.render(NewAdminSubmitButton(submitLabel))
                    }
                    .class("new-admin-form__actions")
                }
            }
        }
        return context.render(form)
    }

    private func homePagePicker(
        _ field: HomePageState,
        context: inout RenderContext
    ) -> Section {

        context.render(
            NewAdminFormFieldSelectAutocomplete(
                state: .init(
                    name: field.key,
                    label: field.label,
                    placeholder: "Search pages by title...",
                    options: field.options,
                    error: field.error,
                    isDisabled: !state.canEdit
                )
            )
        )
    }

    private func imagePicker(
        _ field: FieldState,
        context: inout RenderContext
    ) -> Section {

        let browsePath =
            "/admin/media/assets/?picker=1&field=\(field.key.queryEncoded())&extensions=png,jpg,jpeg,webp"
        return context.render(
            NewAdminFormFieldMediaPicker(
                state: .init(
                    field: .init(
                        key: field.key,
                        label: field.label,
                        value: field.value,
                        error: field.error
                    ),
                    selectedAsset:
                        NewAdminMediaAsset.metadataImageURL(
                            field.value
                        )
                        .map {
                            .init(
                                id: $0.id,
                                storageKey: $0.storageKey,
                                baseName: $0.baseName,
                                type: $0.type,
                                title: $0.title,
                                altText: $0.altText,
                                status: $0.status
                            )
                        },
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
                style: rows <= 4 ? .small : .large,
                isDisabled: !state.canEdit
            )
        )
    }
}
