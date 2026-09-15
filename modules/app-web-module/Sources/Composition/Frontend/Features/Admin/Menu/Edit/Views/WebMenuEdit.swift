import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMenuEdit: Component {

    struct State {
        let id: String
        let form: WebMenuForm.State
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
            context.build(AdminWebMenuTabs(menuID: state.id, active: .details))
            context.build(
                WebMenuForm(
                    state: state.form,
                    action: WebMenuRoutes.edit(RouterPath(state.id))
                        .description,
                    submitLabel: "Edit menu",
                    removeHref: WebMenuRoutes.details(RouterPath(state.id))
                        .appendingPath(RouterPath("remove")).description,
                    removeLabel: "Remove menu"
                )
            )
        }
        .class("cms-section")
    }
}
