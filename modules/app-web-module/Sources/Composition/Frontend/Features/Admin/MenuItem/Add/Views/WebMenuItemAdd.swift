import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemAdd: Component {

    struct State {
        let menuId: String
        let form: WebMenuItemForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add item",
                        description: "Add a link to the navigation menu."
                    )
                )
            )
            context.render(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.render(
                WebMenuItemForm(
                    state: state.form,
                    action: WebMenuItemRoutes.add(RouterPath(state.menuId))
                        .description,
                    submitLabel: "Add item"
                )
            )
        }
        .class("cms-section")
    }
}
