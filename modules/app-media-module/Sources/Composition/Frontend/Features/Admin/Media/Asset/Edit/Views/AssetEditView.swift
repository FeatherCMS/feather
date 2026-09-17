import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetEditView: Component {
    struct State {
        let model: AdminEditMediaAssetModel
        let permissions: NewAdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.permissions.allows(MediaPermissions.Assets.update) {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message: "Your account cannot edit media assets."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                context.build(
                    NewAdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Edit media asset",
                            description: "Update the metadata for this asset."
                        )
                    )
                )
                if let error = state.model.error {
                    P(error).class("new-admin-form__error")
                }
                let form = NewAdminForm(
                    action:
                        MediaAssetRoutes.edit(
                            RouterPath(state.model.id)
                        )
                        .description
                ) {
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "url",
                                label: "URL",
                                value: state.model.url,
                                isReadOnly: true
                            )
                        )
                    )
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "extension",
                                label: "Extension",
                                value: state.model.extension,
                                isReadOnly: true
                            )
                        )
                    )
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "status",
                                label: "Status",
                                value: state.model.status,
                                isReadOnly: true
                            )
                        )
                    )
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "sizeBytes",
                                label: "Size bytes",
                                value: "\(state.model.sizeBytes)",
                                isReadOnly: true
                            )
                        )
                    )
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "title",
                                label: "Title",
                                value: state.model.title
                            )
                        )
                    )
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "altText",
                                label: "Alt text",
                                value: state.model.altText
                            )
                        )
                    )
                    Div {
                        context.build(NewAdminSubmitButton("Save changes"))
                    }
                    .class("new-admin-form__actions")
                }
                context.build(form)
            }
        }
        .class("cms-section")
    }
}
