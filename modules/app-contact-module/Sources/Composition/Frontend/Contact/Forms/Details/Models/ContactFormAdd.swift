import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct ContactFormAdd: Leaf {
    struct State {
        let form: ContactFormForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()
            H1("Add contact form")
            ContactFormForm(
                state: state.form,
                action: "/admin/contact/forms/add/",
                submitLabel: "Add form"
            ).html()
        }
        .class("cms-section")
    }

}
