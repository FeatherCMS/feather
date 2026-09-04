import BlogAdminAPI
import BlogAppAPI
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebFrontend
import WebComponents
import WebBuilders

struct BlogPostAdd: Leaf {

    struct State {
        let form: BlogPostForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

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
