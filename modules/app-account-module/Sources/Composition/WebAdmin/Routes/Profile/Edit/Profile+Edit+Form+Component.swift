import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

extension Profile.Edit.Form {
    struct Component: WebComponents.Component {
        let routes: Profile.Router.Routes

        struct FieldState: Sendable {
            var key: String
            var label: String
            var value: String?
            var error: String?
        }

        struct State: Sendable {
            var firstName: FieldState
            var lastName: FieldState
            var profileImageAssetId: FieldState
            var selectedImageAsset: AdminMediaAsset?
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
        let action: String
        var submitLabel: String = "Save changes"

        func html(context: inout BuilderContext) -> Form {
            let form = AdminForm(action: action, nonceToken: state.nonceToken) {
                if let success = state.success {
                    P(success).class("success")
                }
                if let error = state.error {
                    P(error).class("error")
                }

                context.build(
                    AdminFormFieldMediaPicker(
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
                                "/admin/media/assets/?picker=1&field=\(state.profileImageAssetId.key.queryEncoded())&extensions=\(AllowedExtensions.images.queryValue)",
                            defaultFolderPath: "account/profiles",
                            allowedExtensions: .images,
                            previewStyle: .circular
                        )
                    )
                )

                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: state.firstName.key,
                            label: state.firstName.label,
                            value: state.firstName.value,
                            error: state.firstName.error
                        )
                    )
                )
                context.build(
                    AdminFormFieldInput(
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
                        context.build(AdminSubmitButton(submitLabel))
                        context.build(
                            AdminButton(
                                "View profile",
                                href: routes.profile.path,
                                style: .secondary
                            )
                        )
                    }
                    .class("admin-form__actions")
                }
            }
            return context.build(form)
        }
    }
}
