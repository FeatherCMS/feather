import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuEdit: Component {

    struct State {
        let id: String
        let form: WebMenuForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit menu",
                        description: "Update the navigation menu configuration."
                    )
                )
            )
            context.render(AdminWebMenuTabs(menuID: state.id, active: .details))
            context.render(
                WebMenuForm(
                    state: state.form,
                    action: WebMenuRoutes.edit(RouterPath(state.id)).description,
                    submitLabel: "Edit menu",
                    removeHref: WebMenuRoutes.details(RouterPath(state.id)).appendingPath(RouterPath("remove")).description,
                    removeLabel: "Remove menu"
                )
            )
        }
        .class("cms-section")
    }
}
