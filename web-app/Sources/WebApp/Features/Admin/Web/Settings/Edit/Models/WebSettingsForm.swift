import HTML
import SGML
import WebStandards

struct WebSettingsForm: Component, FlowContent {

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

    struct HomePageState: Object {
        var key: String
        var label: String
        var value: String?
        var options: [AdminAutocompleteField.OptionState]
        var error: String?
    }

    struct State: Object {
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

    func content() -> some BasicTag {
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
            field(state.title)
            textarea(state.excerpt, rows: 4)
            imagePicker(state.metaImage)
            homePagePicker(state.homePage)
            field(state.locale)
            field(state.timezone)

            H2("Theme")
            field(state.primaryColor)
            field(state.secondaryColor)
            field(state.tertiaryColor)
            field(state.primaryFont)
            field(state.secondaryFont)

            H2("Code injection")
            textarea(state.css, rows: 10)
            textarea(state.js, rows: 10)

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

    private func field(
        _ field: FieldState
    ) -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: field.label, required: false)

                Input()
                    .type(.text)
                    .class("text-input")
                    .id(field.key)
                    .name(field.key)
                    .value(field.value)
                    .if(!state.canEdit) {
                        $0.setAttribute(name: "disabled", value: "")
                    }
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
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

    private func homePagePicker(
        _ field: HomePageState
    ) -> some FlowContent {
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
        )
    }

    private func imagePicker(
        _ field: FieldState
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
                selectedAsset: AdminMediaAssetReferenceModel.metadataImageURL(
                    field.value
                ),
                browsePath: browsePath,
                allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                outputMode: .originalURL
            )
        )
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
                    .if(!state.canEdit) {
                        $0.setAttribute(name: "disabled", value: "")
                    }
            }
            if let error = field.error {
                Span(error).class("field-error")
            }
        }
        .if(field.error != nil) { $0.class("has-error") }
    }
}
