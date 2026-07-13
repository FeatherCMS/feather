import HTML
import SGML
import WebStandards

struct ContactNewsletterAddView: Component {
    struct State { let name: String; let error: String?; let breadcrumb: AdminBreadcrumb.State }
    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Add campaign")
            if let error = state.error { P(error).class("error") }
            Form {
                Section {
                    Label { AdminFieldLabel(label: "Name", required: true); Input().type(.text).class("text-input").name("name").value(state.name).id("name").required() }
                }
                Section { Div { Button("Add").type(.submit) }.class("button-row") }
            }.method(.post).action("/admin/newsletters/add/").class("cms-form")
        }.class("cms-section")
    }
}
