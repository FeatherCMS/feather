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
                NewAdminFormFieldInput(
                    state: .init(
                        name: state.profileImageAssetId.key,
                        label: state.profileImageAssetId.label,
                        value: state.profileImageAssetId.value,
                        error: state.profileImageAssetId.error,
                        help: "Optional media asset identifier."
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
