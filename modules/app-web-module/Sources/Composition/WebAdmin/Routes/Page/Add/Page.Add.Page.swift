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

extension Page.Add {
    struct Component: WebComponents.Component {

        struct State {
            let form: Page.Form.Component.State
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
                    Page.Form.Component(
                        state: state.form,
                        action: state.routes.add.path,
                        submitLabel: "Add page"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
