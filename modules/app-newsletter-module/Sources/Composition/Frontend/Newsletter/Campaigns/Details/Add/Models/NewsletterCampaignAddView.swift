import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct NewsletterCampaignAddView: Leaf {
    struct State {
        let name: String
        let fromEmail: String
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()
            H1("Add campaign")
            if let error = state.error { P(error).class("error") }
            Form {
                Section {
                    Label {
                        AdminFieldLabel(label: "Name", required: true).renderHTML()
                        Input().type(.text).class("text-input").name("name")
                            .value(state.name).id("name").required()
                    }
                }
                Section {
                    Label {
                        AdminFieldLabel(label: "From email", required: true).renderHTML()
                        Input().type(.email).class("text-input")
                            .name("fromEmail").value(state.fromEmail)
                            .id("fromEmail").required()
                    }
                }
                Section {
                    Div { Button("Add").type(.submit) }.class("button-row")
                }
            }
            .method(.post).action("/admin/newsletters/add/").class("cms-form")
        }
        .class("cms-section")
    }
}
