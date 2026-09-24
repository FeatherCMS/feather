import FeatherAdmin
import FeatherValidation
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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: MediaFolderRoutes.breadcrumb)
            )
            context.build(
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
                context.build(
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
                    context.build(NewAdminSubmitButton("Add folder"))
                }
                .class("new-admin-form__actions")
            }
            context.build(form)
        }
        .class("cms-section")
    }
}
