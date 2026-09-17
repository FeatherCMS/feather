import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AccountProfileForm: Component {

    struct FieldState: FeatherAdmin.Object {
        var key: String
        var label: String
        var value: String?
        var error: String?
    }

    struct State: FeatherAdmin.Object {
        var firstName: FieldState
        var lastName: FieldState
        var profileImageAssetId: FieldState
        var selectedImageAsset: NewAdminMediaAsset?
        var error: String?
        var success: String?
        var nonceToken: String? = nil

        mutating func apply(
            errors: [String: String]
        ) {
            firstName.error = errors[firstName.key]
            lastName.error = errors[lastName.key]
            profileImageAssetId.error = errors[profileImageAssetId.key]
        }
    }

    var state: State
    var action: String = "/admin/account/profile/edit/"
    var submitLabel: String = "Edit profile"

    func html(context: inout BuilderContext) -> Form {
        let form = NewAdminForm(action: action, nonceToken: state.nonceToken) {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            context.build(
                NewAdminFormFieldMediaPicker(
                    state: .init(
                        field: .init(
                            key: state.profileImageAssetId.key,
                            label: state.profileImageAssetId.label,
                            value: state.profileImageAssetId.value,
                            error: state.profileImageAssetId.error
                        ),
                        selectedAsset: state.selectedImageAsset.map {
                            .init(
                                id: $0.id,
                                name: $0.name,
                                slugPath: $0.slugPath,
                                url: $0.url,
                                extension: $0.extension,
                                contentType: $0.contentType,
                                sizeBytes: $0.sizeBytes,
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
                        name: state.firstName.key,
                        label: state.firstName.label,
                        value: state.firstName.value,
                        error: state.firstName.error
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.lastName.key,
                        label: state.lastName.label,
                        value: state.lastName.value,
                        error: state.lastName.error
                    )
                )
            )

            Section {
                Div {
                    context.build(NewAdminSubmitButton(submitLabel))
                }
                .class("new-admin-form__actions")
            }
        }
        return context.build(form)
    }
}
