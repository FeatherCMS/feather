import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

struct AuthProfileForm: Component, FlowContent {

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
        var selectedImageAsset: AdminMediaAssetReferenceModel?
        var error: String?
        var success: String?

        mutating func apply(
            errors: [String: String]
        ) {
            firstName.error = errors[firstName.key]
            lastName.error = errors[lastName.key]
            profileImageAssetId.error = errors[profileImageAssetId.key]
        }
    }

    var state: State
    var action: String = "/admin/auth/profile/edit/"
    var submitLabel: String = "Edit profile"

    func content() -> some BasicTag {
        Form {
            if let success = state.success {
                P(success).class("success")
            }
            if let error = state.error {
                P(error).class("error")
            }

            AdminMediaAssetPicker(
                state: .init(
                    field: .init(
                        key: state.profileImageAssetId.key,
                        label: state.profileImageAssetId.label,
                        value: state.profileImageAssetId.value,
                        error: state.profileImageAssetId.error
                    ),
                    selectedAsset: state.selectedImageAsset,
                    browsePath:
                        "/admin/media/assets/?picker=1&field=\(state.profileImageAssetId.key.queryEncoded())&extensions=png,jpg,jpeg,webp",
                    allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                    outputMode: .assetId
                )
            )

            FormInputField(
                name: state.firstName.key,
                label: state.firstName.label,
                value: state.firstName.value,
                error: state.firstName.error,
                isRequired: false,
                inputClass: "text-input"
            )
            FormInputField(
                name: state.lastName.key,
                label: state.lastName.label,
                value: state.lastName.value,
                error: state.lastName.error,
                isRequired: false,
                inputClass: "text-input"
            )

            Section {
                Div {
                    Button(submitLabel)
                        .type(.submit)
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(action)
        .class("cms-form")
    }
}
