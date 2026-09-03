import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AccountProfileForm: Component, FlowContent {
    struct State {
        let firstName: String?
        let lastName: String?
        let profileImageAssetId: String?
        let canEdit: Bool
        let action: String
    }

    let state: State

    func content() -> some BasicTag {
        Form {
            FormInputField(
                name: "firstName",
                label: "First name",
                value: state.firstName,
                error: nil,
                placeholder: "First name",
                isRequired: false,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            FormInputField(
                name: "lastName",
                label: "Last name",
                value: state.lastName,
                error: nil,
                placeholder: "Last name",
                isRequired: false,
                isDisabled: !state.canEdit,
                inputClass: "text-input"
            )
            if state.canEdit {
                AdminMediaAssetPicker(
                    state: .init(
                        field: .init(
                            key: "profileImageAssetId",
                            label: "Profile image",
                            value: state.profileImageAssetId,
                            error: nil
                        ),
                        selectedAsset: nil,
                        browsePath:
                            "/admin/media/assets/?picker=1&field=profileImageAssetId&extensions=png,jpg,jpeg,webp",
                        allowedExtensions: ["png", "jpg", "jpeg", "webp"],
                        outputMode: .assetId
                    )
                )
            }
            else {
                FormInputField(
                    name: "profileImageAssetId",
                    label: "Profile image asset ID",
                    value: state.profileImageAssetId,
                    error: nil,
                    placeholder: "Asset ID",
                    isRequired: false,
                    isDisabled: true,
                    inputClass: "text-input"
                )
            }
            if state.canEdit {
                Div {
                    Button("Save profile").type(.submit)
                }
                .class("button-row")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action(state.action)
        .class("cms-form")
    }
}
