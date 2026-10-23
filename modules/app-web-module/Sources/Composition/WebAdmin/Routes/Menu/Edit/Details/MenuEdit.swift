import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebModule

struct MenuEdit: Component {

    struct State {
        let id: String
        let form: MenuForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: WebModule.Menu.Router.Routes
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
                    active: .details,
                    detailsPath: state.routes.editPath(state.id),
                    itemsPath: state.routes.items.path(
                        parameter: "id",
                        value: state.id
                    )
                )
            )
            context.build(
                MenuForm(
                    state: state.form,
                    action: state.routes.editPath(state.id),
                    submitLabel: "Edit menu",
                    removeHref: state.routes.detailsRemovePath(state.id),
                    removeLabel: "Remove menu"
                )
            )
        }
        .class("cms-section")
    }
}
