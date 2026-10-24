import FeatherWebAdmin
import HTML
import SGML
import SystemModule
import WebBuilders
import WebComponents

extension Variable.Edit {
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
                        title: "Edit system variable",
                        description:
                            "Update this configuration value used by the application."
                    )
                )
            )
            context.build(form)
        }
        .class("cms-section")
    }
    }
}
