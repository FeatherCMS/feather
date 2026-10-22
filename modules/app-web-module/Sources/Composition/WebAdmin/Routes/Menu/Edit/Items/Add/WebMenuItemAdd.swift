import FeatherValidation
import FeatherWebAdmin
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
                AdminWebMenuTabs(menuID: state.menuId, active: .items)
            )
            context.build(
                AdminRelationshipGroup(
                    pageHeader: .secondary(
                        title: "Add item",
                        description: "Add a link to the navigation menu."
                    )
                ) {
                    context.build(
                        WebMenuItemForm(
                            state: state.form,
                            action:
                                WebMenuItemRoutes.add(
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
