import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormAdd: Component {
    struct State {
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))
            H1("Add contact form")
            context.render(ContactFormForm(
                state: state.form,
                action: "/admin/contact/forms/add/",
                submitLabel: "Add form"
            ))
        }
        .class("cms-section")
    }

}
