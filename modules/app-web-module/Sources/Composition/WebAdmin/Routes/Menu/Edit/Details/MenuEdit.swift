import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct MenuEdit: Component {

    struct State {
        let id: String
        let form: MenuForm.State
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
            context.build(AdminMenuTabs(menuID: state.id, active: .details))
            context.build(
                MenuForm(
                    state: state.form,
                    action: MenuRoutes.edit(RouterPath(state.id))
                        .description,
                    submitLabel: "Edit menu",
                    removeHref: MenuRoutes.details(RouterPath(state.id))
                        .appendingPath(RouterPath("remove")).description,
                    removeLabel: "Remove menu"
                )
            )
        }
        .class("cms-section")
    }
}
