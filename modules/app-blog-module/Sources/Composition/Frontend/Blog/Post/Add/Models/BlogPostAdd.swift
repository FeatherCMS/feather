import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
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
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add post",
                        description: "Create a new blog post."
                    )
                )
            )
            context.build(
                BlogPostForm(
                    state: state.form,
                    action: "/admin/blog/posts/add/",
                    submitLabel: "Add post"
                )
            )
        }
        .class("cms-section")
    }
}
