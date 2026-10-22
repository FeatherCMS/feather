import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import Builders
import Components

struct MenuItemAdd: Component {

    struct State {
        let menuId: String
        let form: MenuItemForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
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
                AdminMenuTabs(menuID: state.menuId, active: .items)
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
                            action:
                                MenuItemRoutes.add(
                                    RouterPath(state.menuId)
                                )
                                .description,
                            submitLabel: "Add item"
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
