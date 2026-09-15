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

struct BlogPostEdit: Component {

    struct State {
        let id: String
        let form: BlogPostForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit post",
                        description: "Update this blog post."
                    )
                )
            )
            context.build(
                BlogPostForm(
                    state: state.form,
                    metadataHref:
                        "/admin/blog/posts/\(state.id)/edit/metadata/\(state.id)/",
                    action: "/admin/blog/posts/\(state.id)/edit/",
                    submitLabel: "Edit post",
                    removeHref: "/admin/blog/posts/\(state.id)/remove/",
                    removeLabel: "Remove post"
                )
            )
        }
        .class("cms-section")
    }
}
