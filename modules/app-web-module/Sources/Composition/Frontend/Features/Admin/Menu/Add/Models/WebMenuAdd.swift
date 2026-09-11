import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuAdd: Component {

    struct State {
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add menu")
            context.render(WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/add/",
                submitLabel: "Add menu"
            ))
        }
        .class("cms-section")
    }
}
