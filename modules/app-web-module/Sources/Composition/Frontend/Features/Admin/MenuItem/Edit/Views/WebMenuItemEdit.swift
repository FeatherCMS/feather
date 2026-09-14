import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuItemEdit: Component {

    struct State {
        let menuId: String
        let id: String
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
                        title: "Edit item",
                        description: "Update the navigation menu link."
                    )
                )
            )
            context.render(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.render(
                WebMenuItemForm(
                    state: state.form,
                    action: WebMenuItemRoutes.edit(
                        RouterPath(state.menuId),
                        RouterPath(state.id)
                    ).description,
                    submitLabel: "Edit item",
                    removeHref: WebMenuItemRoutes.details(
                        RouterPath(state.menuId),
                        RouterPath(state.id)
                    ).appendingPath(RouterPath("remove")).description,
                    removeLabel: "Remove item"
                )
            )
        }
        .class("cms-section")
    }
}
