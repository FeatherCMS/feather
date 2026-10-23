import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebDomain
import WebModule

struct MenuItemAdd: Component {

    struct State {
        let menuId: String
        let form: MenuItemForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: MenuItem.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Edit menu",
                        description: "Update the navigation menu configuration."
                    )
                )
            )
            context.build(
                AdminMenuTabs(
                    active: .items,
                    detailsPath: state.routes.editPath(state.menuId),
                    itemsPath: state.routes.itemsPath(state.menuId)
                )
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Add item",
                        description: "Add a link to the navigation menu."
                    )
                ) {
                    context.build(
                        MenuItemForm(
                            state: state.form,
                            action: state.routes.itemsAddPath(state.menuId),
                            submitLabel: "Add item"
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
