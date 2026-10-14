import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuAdd: Component {

    struct State {
        let form: WebMenuForm.State
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
                WebMenuForm(
                    state: state.form,
                    action: WebMenuRoutes.add.description,
                    submitLabel: "Add menu"
                )
            )
        }
        .class("cms-section")
    }
}
