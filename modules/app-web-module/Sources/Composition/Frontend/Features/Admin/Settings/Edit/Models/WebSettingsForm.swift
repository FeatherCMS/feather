import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebSettingsForm: Leaf {

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
        var options: [AdminAutocompleteField.OptionState]
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

    func renderHTML() -> Form {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            H2("Branding")
            imagePicker(state.logo)
            imagePicker(state.logoDark)

            H2("SEO")
            checkbox(state.noIndex)
            FormInputField(
                name: state.title.key,
                label: state.title.label,
                value: state.title.value,
                error: state.title.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            textarea(state.excerpt, rows: 4).renderHTML()
            imagePicker(state.metaImage)
            homePagePicker(state.homePage)
            FormInputField(
                name: state.locale.key,
                label: state.locale.label,
                value: state.locale.value,
                error: state.locale.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            FormInputField(
                name: state.timezone.key,
                label: state.timezone.label,
                value: state.timezone.value,
                error: state.timezone.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()

            H2("Theme")
            FormInputField(
                name: state.primaryColor.key,
                label: state.primaryColor.label,
                value: state.primaryColor.value,
                error: state.primaryColor.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            FormInputField(
                name: state.secondaryColor.key,
                label: state.secondaryColor.label,
                value: state.secondaryColor.value,
                error: state.secondaryColor.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            FormInputField(
                name: state.tertiaryColor.key,
                label: state.tertiaryColor.label,
                value: state.tertiaryColor.value,
                error: state.tertiaryColor.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            FormInputField(
                name: state.primaryFont.key,
                label: state.primaryFont.label,
                value: state.primaryFont.value,
                error: state.primaryFont.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()
            FormInputField(
                name: state.secondaryFont.key,
                label: state.secondaryFont.label,
                value: state.secondaryFont.value,
                error: state.secondaryFont.error,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            ).renderHTML()

            H2("Code injection")
            textarea(state.css, rows: 10).renderHTML()
            textarea(state.js, rows: 10).renderHTML()

            if state.canEdit {
                Section {
                    Div {
                        Button(submitLabel)
                            .type(.submit)
                    }
                    .class("button-row")
                }
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
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

    private func homePagePicker(
        _ field: HomePageState
    ) -> Section {
        AdminAutocompleteField(
            state: .init(
                key: field.key,
                label: field.label,
                placeholder: "Search pages by title...",
                options: field.options,
                error: field.error,
                selectionMode: .single,
                isEnabled: state.canEdit
            )
        ).renderHTML()
    }

    private func imagePicker(
        _ field: FieldState
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
                selectedAsset: AdminMediaAssetReferenceModel.metadataImageURL(
                    field.value
                ),
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
            rows: rows,
            isDisabled: !state.canEdit
        )
    }
}
