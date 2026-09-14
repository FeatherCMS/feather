import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaFolderAddView: Component {
    struct State {
        let form: FormState
    }

    struct FormState {
        var parentId: String = ""
        var name: String = ""
        var view: String = "grid"
        var error: String? = nil
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(links: MediaFolderRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add media folder",
                        description:
                            "Create a folder for organizing media assets."
                    )
                )
            )
            if let error = state.form.error {
                P(error).class("new-admin-form__error")
            }
            let form = NewAdminForm(
                action: MediaFolderRoutes.add.description,
                hiddenFields: [
                    .init(name: "parentId", value: state.form.parentId),
                    .init(name: "view", value: state.form.view),
                ]
            ) {
                context.render(
                    NewAdminFormFieldInput(
                        state: .init(
                            name: "name",
                            label: "Folder name",
                            value: state.form.name,
                            isRequired: true
                        )
                    )
                )
                Div {
                    context.render(NewAdminSubmitButton("Add folder"))
                }
                .class("new-admin-form__actions")
            }
            context.render(form)
        }
        .class("cms-section")
    }
}
