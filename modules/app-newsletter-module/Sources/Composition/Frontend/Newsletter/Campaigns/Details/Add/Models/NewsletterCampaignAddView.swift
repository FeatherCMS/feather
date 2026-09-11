import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct NewsletterCampaignAddView: Component {
    struct State {
        let name: String
        let fromEmail: String
        let error: String?
        let breadcrumb: AdminBreadcrumb.State
    }
    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Add campaign")
            if let error = state.error { P(error).class("error") }
            Form {
                Section {
                    Label {
                        context.render(
                            AdminFieldLabel(label: "Name", required: true)
                        )
                        Input().type(.text).class("text-input").name("name")
                            .value(state.name).id("name").required()
                    }
                }
                Section {
                    Label {
                        context.render(
                            AdminFieldLabel(label: "From email", required: true)
                        )
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
