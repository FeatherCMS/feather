import BlogModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

import protocol SGML.BasicTag

extension Tag.Add {
    struct Component: WebComponents.Component {
        struct State {
            let form: Tag.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let routes: Tag.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Add tag",
                            description: "Create a new blog tag."
                        )
                    )
                )
                Div {
                    context.build(
                        Tag.Form(
                            state: state.form,
                            action: state.routes.tagAdd(),
                            submitLabel: "Add tag"
                        )
                    )
                }
            }
            .class("cms-section")
        }
    }
}
