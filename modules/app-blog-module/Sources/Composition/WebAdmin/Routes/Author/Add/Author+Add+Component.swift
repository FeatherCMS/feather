import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents

import protocol SGML.BasicTag

extension Author.Add {
    struct Component: WebComponents.Component {
        struct State {
            let form: Author.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Author.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add author",
                            description: "Create a new blog author."
                        )
                    )
                )
                context.build(
                    Author.Form(
                        state: state.form,
                        action: state.routes.authorAdd().description,
                        submitLabel: "Add author"
                    )
                )
            }
            .class("cms-section")
        }
    }
}
