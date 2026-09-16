import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import HTML
import Hummingbird
import MediaFrontend
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorForm: Component {
    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }
    struct State: FeatherAdmin.Object {
        var name: FieldState
        var excerpt: FieldState
        var content: FieldState
        var profileImageAssetId: FieldState
        var metadata: AdminMetadataFields.State
        var selectedProfileImage: NewAdminMediaAsset?
        var canSelectProfileImage: Bool
        var canUploadProfileImage: Bool
        var error: String?

        mutating func apply(errors: [String: String]) {
            name.error = errors[name.key]
            excerpt.error = errors[excerpt.key]
            content.error = errors[content.key]
            profileImageAssetId.error = errors[profileImageAssetId.key]
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

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action) {
            if let error = state.error {
                P(error).class("new-admin-form__error")
            }
            context.build(NewAdminTabBar(links: tabLinks()))
            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: state.profileImageAssetId.key,
                            label: state.profileImageAssetId.label,
                            value: state.profileImageAssetId.value,
                            error: state.profileImageAssetId.error
                        ),
                        selectedAsset: state.selectedProfileImage.map {
                            .init(
                                id: $0.id,
                                storageKey: $0.storageKey,
                                baseName: $0.baseName,
                                type: $0.type,
                                variants: $0.variants,
                                title: $0.title,
                                altText: $0.altText,
                                status: $0.status
                            )
                        },
                        browsePath:
                            "/admin/media/assets/?picker=1&field=\(state.profileImageAssetId.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                        allowedExtensions: ["png", "jpg", "jpeg", "webp"]
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.name.key,
                        label: state.name.label,
                        value: state.name.value,
                        error: state.name.error,
                        isRequired: true
                    )
                )
            )
            context.build(
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
            context.build(
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
                context.build(
                    NewAdminSubmitButton(submitLabel, style: .primary)
                )
                if let publishLabel {
                    Button(publishLabel).type(.submit).name("submitAction")
                        .value("publish").class("button", "secondary")
                }
                if let removeHref {
                    context.build(
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
        return context.build(form)
    }

    private func tabLinks() -> [NewAdminTabBar.Link] {
        var links = [
            NewAdminTabBar.Link(
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
