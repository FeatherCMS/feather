import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormEdit: Component {
    struct State {
        let id: String
        let isEdited: Bool
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminContactFormTabs(formId: state.id, active: .details))
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Edit contact form")
            if state.isEdited { P("Contact form edited successfully.") }
            context.render(ContactFormForm(
                state: state.form,
                action: "/admin/contact/forms/\(state.id)/edit/",
                submitLabel: "Save"
            ))
        }
        .class("cms-section")
    }

}
