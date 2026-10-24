import FeatherWebAdmin
import HTML
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Variable.Add {
    struct Page: Component {
    let routes: Variable.Router.Routes
    let form: Form

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminBreadcrumb(
                    links: routes.breadcrumb
                )
            )
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add system variable",
                        description:
                            "Create a configuration value for the application."
                    )
                )
            )
            context.build(form)
        }
        .class("cms-section")
    }
    }
}
