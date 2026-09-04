import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebPageAdd: Leaf {

    struct State {
        let form: WebPageForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

            H1("Add page")
            WebPageForm(
                state: state.form,
                action: "/admin/web/pages/add/",
                submitLabel: "Add page",
                publishLabel: "Publish page"
            ).html()
        }
        .class("cms-section")
    }
}
