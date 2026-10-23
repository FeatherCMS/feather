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

struct MenuAdd: Component {

    struct State {
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
                        title: "Add menu",
                        description:
                            "Create a navigation menu for the public website."
                    )
                )
            )
            context.build(
                MenuForm(
                    state: state.form,
                    action: state.routes.add.path,
                    submitLabel: "Add menu"
                )
            )
        }
        .class("cms-section")
    }
}
