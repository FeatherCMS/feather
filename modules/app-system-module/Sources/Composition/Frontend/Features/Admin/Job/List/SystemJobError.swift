import FeatherAdmin
import HTML
import SGML
import WebBuilders
import WebComponents

struct SystemJobError: Component {
    let message: String
    let breadcrumb: AdminBreadcrumb.State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: breadcrumb))
            H1("Unable to load worker jobs")
            P(message)
        }
        .class("cms-section")
    }
}
