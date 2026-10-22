import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct MenuAdd: Component {

    struct State {
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
                        title: "Add menu",
                        description:
                            "Create a navigation menu for the public website."
                    )
                )
            )
            context.build(
                MenuForm(
                    state: state.form,
                    action: MenuRoutes.add.description,
                    submitLabel: "Add menu"
                )
            )
        }
        .class("cms-section")
    }
}
