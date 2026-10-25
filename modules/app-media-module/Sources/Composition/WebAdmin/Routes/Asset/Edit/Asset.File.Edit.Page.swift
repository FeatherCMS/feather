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

extension Asset.File.Edit {
    struct Page: Component {
        struct State {
            let model: Model
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
                                    "Your account cannot edit media assets."
                            ),
                            icon: FeatherIcons.lock()
                        )
                    )
                }
                else {
                    context.build(
                        AdminBreadcrumb(links: state.routes.file.breadcrumb)
                    )
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "Edit media asset",
                                description:
                                    "Update the metadata for this asset."
                            )
                        )
                    )
                    if let error = state.model.error {
                        P(error).class("admin-form__error")
                    }
                    let form = AdminForm(
                        action: state.routes.file.editPath(state.model.id)
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
}
