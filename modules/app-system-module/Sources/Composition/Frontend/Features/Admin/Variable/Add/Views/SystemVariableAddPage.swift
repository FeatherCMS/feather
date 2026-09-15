import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableAddPage: Component {
    let form: SystemVariableAddForm

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemVariableRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
