import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogTagAdd: Component {

    struct State {
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add tag")
            Div {
                context.render(BlogTagForm(
                state: state.form,
                action: "/admin/blog/tags/add/",
                submitLabel: "Add tag",
                publishLabel: "Publish tag"
                ))
            }
        }
        .class("cms-section")
    }
}
