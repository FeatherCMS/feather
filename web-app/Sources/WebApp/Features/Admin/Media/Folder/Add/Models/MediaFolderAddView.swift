import HTML
import SGML
import WebStandards

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

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add media folder")
            if let error = state.form.error {
                P(error).class("error")
            }
            Form {
                Input().type(.hidden).name("parentId")
                    .value(state.form.parentId).id("parentId")
                Input().type(.hidden).name("view")
                    .value(state.form.view).id("view")

                Section {
                    Label {
                        AdminFieldLabel(label: "Folder name", required: true)
                        Input().type(.text).class("text-input").name("name")
                            .value(state.form.name).id("name")
                            .setAttribute(name: "required", value: "")
                    }
                }

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
