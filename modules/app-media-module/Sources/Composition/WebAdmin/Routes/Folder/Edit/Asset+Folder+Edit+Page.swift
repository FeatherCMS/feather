import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

import class Foundation.ByteCountFormatter

extension Asset.Folder.Edit {
    struct Page: Component {
        struct State {
            let model: Asset.Folder.Edit.Model
            let permissions: AdminListActions
            let routes: Asset.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                if !state.permissions.allows(Asset.Permissions.update) {
                    context.build(
                        AdminStatusView(
                            state: .init(
                                title: "Forbidden",
                                message:
                                    "Your account cannot edit media folders."
                            ),
                            icon: FeatherIcons.lock()
                        )
                    )
                }
                else {
                    context.build(
                        AdminBreadcrumb(links: state.routes.folder.breadcrumb)
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
                        action: state.routes.folder.editPath(state.model.id)
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
}
