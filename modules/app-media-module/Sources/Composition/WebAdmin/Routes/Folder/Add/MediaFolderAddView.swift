import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaFolderAddView: Component {
    struct State {
        let routes: Asset.Router.Routes
        let form: FormState
        let isDialog: Bool
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
            if !state.isDialog {
                context.build(
                    AdminBreadcrumb(links: state.routes.folder.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add media folder",
                            description:
                                "Create a folder for organizing media assets."
                        )
                    )
                )
            }
            if let error = state.form.error {
                P(error).class("admin-form__error")
            }
            let form = AdminForm(
                action: formAction(),
                hiddenFields: [
                    .init(name: "parentId", value: state.form.parentId),
                    .init(name: "view", value: state.form.view),
                ]
            ) {
                context.build(
                    AdminFormFieldInput(
                        state: .init(
                            name: "name",
                            label: "Folder name",
                            value: state.form.name,
                            isRequired: true
                        )
                    )
                )
                Div {
                    context.build(AdminSubmitButton("Add folder"))
                }
                .class("admin-form__actions")
            }
            context.build(form)
        }
        .class("cms-section")
    }

    private func formAction() -> String {
        guard state.isDialog else {
            return state.routes.folder.add.path
        }
        return "\(state.routes.folder.add.path)?presentation=dialog"
    }
}
