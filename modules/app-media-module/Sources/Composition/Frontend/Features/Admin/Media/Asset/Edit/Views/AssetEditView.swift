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

struct AssetEditView: Component {
    struct State {
        let model: AdminEditMediaAssetModel
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
                            message: "Your account cannot edit media assets."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                context.build(
                    AdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Edit media asset",
                            description: "Update the metadata for this asset."
                        )
                    )
                )
                if let error = state.model.error {
                    P(error).class("admin-form__error")
                }
                let form = AdminForm(
                    action:
                        MediaAssetRoutes.edit(
                            RouterPath(state.model.id)
                        )
                        .description
                ) {
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "title",
                                label: "Title",
                                value: state.model.title
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "altText",
                                label: "Alt text",
                                value: state.model.altText
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
