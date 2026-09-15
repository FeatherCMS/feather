import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import HTML
import Hummingbird
import MediaFrontend
import WebBuilders
import WebComponents
import WebFrontend

struct BlogTagForm: Component {
    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }
    struct State: FeatherAdmin.Object {
        var title: FieldState
        var excerpt: FieldState
        var content: FieldState
        var imageAssetId: FieldState
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var metadata: AdminMetadataFields.State
        var error: String?

        mutating func apply(errors: [String: String]) {
            title.error = errors[title.key]
            excerpt.error = errors[excerpt.key]
            content.error = errors[content.key]
            imageAssetId.error = errors[imageAssetId.key]
            metadata.apply(errors: errors)
        }
    }
    var state: State
    var metadataHref: String?
    var action: String
    var submitLabel: String
    var publishLabel: String?
    var removeHref: String?
    var removeLabel: String = "Remove"

    func html(context: inout RenderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.render(NewAdminPillTab(links: tabLinks()))
            context.render(
                NewAdminFormFieldMediaPicker(
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
            )
            context.render(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.title.key,
                        label: state.title.label,
                        value: state.title.value,
                        error: state.title.error,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: state.excerpt.key,
                        label: state.excerpt.label,
                        value: state.excerpt.value,
                        error: state.excerpt.error,
                        style: .small,
                        isRequired: true
                    )
                )
            )
            context.render(
                NewAdminFormFieldTextArea(
                    state: .init(
                        name: state.content.key,
                        label: state.content.label,
                        value: state.content.value,
                        error: state.content.error,
                        style: .large,
                        isRequired: true
                    )
                )
            )
            Div {
                context.render(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let publishLabel {
                    Button(publishLabel).type(.submit).name("submitAction")
                        .value("publish").class("button", "secondary")
                }
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
        return context.render(form)
    }

    private func tabLinks() -> [NewAdminPillTab.Link] {
        var links = [
            NewAdminPillTab.Link(
                label: "Details",
                href: action,
                isCurrent: true
            )
        ]
        if let metadataHref {
            links.append(
                .init(label: "Metadata", href: metadataHref, isCurrent: false)
            )
        }
        return links
    }
}
