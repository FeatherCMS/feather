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

struct BlogPostAdd: Component {

    struct State {
        let form: BlogPostForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add post")
            BlogPostForm(
                state: state.form,
                action: "/admin/blog/posts/add/",
                submitLabel: "Add post",
                publishLabel: "Publish post"
            )
        }
        .class("cms-section")
    }
}
