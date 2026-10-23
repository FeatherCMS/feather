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

struct PageAdd: Component {

    struct State {
        let form: PageForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
        let routes: Page.Router.Routes
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add page",
                        description:
                            "Create and publish a page for the public website."
                    )
                )
            )
            context.build(
                PageForm(
                    state: state.form,
                    action: state.routes.add.path,
                    submitLabel: "Add page"
                )
            )
        }
        .class("cms-section")
    }
}
