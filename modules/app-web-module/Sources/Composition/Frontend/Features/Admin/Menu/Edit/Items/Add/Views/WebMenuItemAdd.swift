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

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit menu",
                        description: "Update the navigation menu configuration."
                    )
                )
            )
            context.build(
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.build(
                WebMenuItemGroup {
                    H2("Add item")
                    P("Add a link to the navigation menu.")
                    context.build(
                        WebMenuItemForm(
                            state: state.form,
                            action: WebMenuItemRoutes.add(
                                RouterPath(state.menuId)
                            ).description,
                            submitLabel: "Add item"
                        )
                    )
                }
            )
        }
        .class("cms-section")
    }
}
