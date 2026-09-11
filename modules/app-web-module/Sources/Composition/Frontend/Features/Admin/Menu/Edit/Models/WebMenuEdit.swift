import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMenuEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMenuForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit menu")
            context.render(AdminWebMenuTabs(menuID: state.id, active: .details))
            if state.isEdited { P("Menu edited successfully.") }
            context.render(WebMenuForm(
                state: state.form,
                action: "/admin/web/menus/\(state.id)/edit/",
                submitLabel: "Edit menu",
                removeHref: "/admin/web/menus/\(state.id)/remove/",
                removeLabel: "Remove menu"
            ))
        }
        .class("cms-section")
    }
}
