import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
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

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            if !state.permissions.allows(MediaPermissions.Assets.update) {
                context.render(
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
                context.render(
                    NewAdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
                )
                context.render(
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
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "storageKey",
                                label: "Storage key",
                                value: state.model.storageKey,
                                isReadOnly: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "type",
                                label: "Type",
                                value: state.model.type,
                                isReadOnly: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "status",
                                label: "Status",
                                value: state.model.status,
                                isReadOnly: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "sizeBytes",
                                label: "Size bytes",
                                value: "\(state.model.sizeBytes)",
                                isReadOnly: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "title",
                                label: "Title",
                                value: state.model.title
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "altText",
                                label: "Alt text",
                                value: state.model.altText
                            )
                        )
                    )
                    Div {
                        context.render(NewAdminSubmitButton("Save changes"))
                    }
                    .class("new-admin-form__actions")
                }
                context.render(form)
            }
        }
        .class("cms-section")
    }
}
