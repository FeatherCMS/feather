import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemVariableAddPage: Component {
    let breadcrumb: NewAdminBreadcrumb.State
    let form: SystemVariableAddForm

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(state: breadcrumb))
            context.render(NewAdminPageHeader(state: .init(
                title: "Add system variable",
                description: "Create a configuration value for the application."
            )))
            context.render(form)
        }.class("cms-section")
    }
}
