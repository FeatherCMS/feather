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
            H1("Edit system variable")
            context.render(form)
        }.class("cms-section")
    }
}
