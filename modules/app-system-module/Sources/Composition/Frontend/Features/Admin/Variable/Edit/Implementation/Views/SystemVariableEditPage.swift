import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableEditPage: Component {
    let breadcrumb: NewAdminBreadcrumb.State
    let form: SystemVariableEditForm

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit system variable",
                        description:
                            "Update this configuration value used by the application."
                    )
                )
            )
            context.render(form)
        }
        .class("cms-section")
    }
}
