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

import class Foundation.ByteCountFormatter

struct MediaFolderEditView: Component {
    struct State {
        let model: AdminEditMediaFolderModel
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
                            message: "Your account cannot edit media folders."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                context.build(
                    NewAdminBreadcrumb(links: MediaFolderRoutes.breadcrumb)
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Edit media folder",
                            description: "Update this media folder."
                        )
                    )
                )
                if let error = state.model.error {
                    P(error).class("new-admin-form__error")
                }

                context.build(
                    NewAdminDetailField(
                        label: "Slug path",
                        value: state.model.slugPath
                    )
                )
                context.build(
                    NewAdminDetailField(
                        label: "Items",
                        value: state.model.assetCount == 1
                            ? "1 item"
                            : "\(state.model.assetCount) items"
                    )
                )
                context.build(
                    NewAdminDetailField(
                        label: "Total size",
                        value: ByteCountFormatter.string(
                            fromByteCount: state.model.totalSizeBytes,
                            countStyle: .file
                        )
                    )
                )

                let form = NewAdminForm(
                    action:
                        MediaFolderRoutes.edit(
                            RouterPath(state.model.id)
                        )
                        .description
                ) {
                    context.build(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "name",
                                label: "Folder name",
                                value: state.model.name,
                                isRequired: true
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
