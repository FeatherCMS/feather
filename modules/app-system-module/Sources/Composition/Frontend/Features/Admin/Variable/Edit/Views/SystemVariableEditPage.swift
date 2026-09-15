import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableEditPage: Component {
    let form: SystemVariableEditForm

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: SystemVariableRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
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
