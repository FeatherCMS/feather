import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebPageAdd: Component {

    struct State {
        let form: WebPageForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add page")
            context.render(
                WebPageForm(
                    state: state.form,
                    action: "/admin/web/pages/add/",
                    submitLabel: "Add page",
                    publishLabel: "Publish page"
                )
            )
        }
        .class("cms-section")
    }
}
