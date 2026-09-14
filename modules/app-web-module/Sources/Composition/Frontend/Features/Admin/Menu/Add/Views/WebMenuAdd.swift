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
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add menu",
                        description:
                            "Create a navigation menu for the public website."
                    )
                )
            )
            context.render(
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
