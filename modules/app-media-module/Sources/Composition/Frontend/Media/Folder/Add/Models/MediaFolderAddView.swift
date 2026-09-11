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
        let breadcrumb: AdminBreadcrumb.State
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
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Add media folder")
            if let error = state.form.error {
                P(error).class("error")
            }
            Form {
                Input().type(.hidden).name("parentId")
                    .value(state.form.parentId).id("parentId")
                Input().type(.hidden).name("view")
                    .value(state.form.view).id("view")

                context.render(
                    FormInputField(
                        name: "name",
                        label: "Folder name",
                        value: state.form.name,
                        isRequired: true,
                        inputClass: "text-input"
                    )
                )

                Section {
                    Div { Button("Add").type(.submit) }.class("button-row")
                }
            }
            .method(.post)
            .action("/admin/media/folders/add/")
            .class("cms-form")
        }
        .class("cms-section")
    }
}
