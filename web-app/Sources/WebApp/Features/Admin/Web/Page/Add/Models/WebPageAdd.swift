import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebPageAdd: Component {

    struct State {
        let form: WebPageForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add page")
            WebPageForm(
                state: state.form,
                action: "/admin/web/pages/add/",
                submitLabel: "Add page",
                publishLabel: "Publish page"
            )
        }
        .class("cms-section")
    }
}
