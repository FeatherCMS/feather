import FeatherAdmin
import FeatherModuleKit
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
        let permissions: AdminListActions
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.permissions.allows(MediaPermissions.Assets.update) {
                context.build(
                    AdminStatusView(
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
                    AdminBreadcrumb(links: MediaFolderRoutes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit media folder",
                            description: "Update this media folder."
                        )
                    )
                )
                if let error = state.model.error {
                    P(error).class("admin-form__error")
                }

                context.build(
                    AdminDetailField(
                        label: "Slug path",
                        value: state.model.slugPath
                    )
                )
                context.build(
                    AdminDetailField(
                        label: "Items",
                        value: state.model.assetCount == 1
                            ? "1 item"
                            : "\(state.model.assetCount) items"
                    )
                )
                context.build(
                    AdminDetailField(
                        label: "Total size",
                        value: ByteCountFormatter.string(
                            fromByteCount: state.model.totalSizeBytes,
                            countStyle: .file
                        )
                    )
                )

                let form = AdminForm(
                    action:
                        MediaFolderRoutes.edit(
                            RouterPath(state.model.id)
                        )
                        .description
                ) {
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "name",
                                label: "Folder name",
                                value: state.model.name,
                                isRequired: true
                            )
                        )
                    )
                    Div {
                        context.build(AdminSubmitButton("Save changes"))
                    }
                    .class("admin-form__actions")
                }
                context.build(form)
            }
        }
        .class("cms-section")
    }
}
