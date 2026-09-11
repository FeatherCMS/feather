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
            H1("Add system variable")
            context.render(form)
        }.class("cms-section")
    }
}
