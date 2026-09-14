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
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Add post",
                        description: "Create a new blog post."
                    )
                )
            )
            context.render(
                BlogPostForm(
                    state: state.form,
                    action: "/admin/blog/posts/add/",
                    submitLabel: "Add post",
                    publishLabel: "Publish post"
                )
            )
        }
        .class("cms-section")
    }
}
