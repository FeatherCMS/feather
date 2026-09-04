import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct MediaFolderAddView: Leaf {
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

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Add media folder")
            if let error = state.form.error {
                P(error).class("error")
            }
            Form {
                Input().type(.hidden).name("parentId")
                    .value(state.form.parentId).id("parentId")
                Input().type(.hidden).name("view")
                    .value(state.form.view).id("view")

                FormInputField(
                    name: "name",
                    label: "Folder name",
                    value: state.form.name,
                    isRequired: true,
                    inputClass: "text-input"
                ).renderHTML()

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
