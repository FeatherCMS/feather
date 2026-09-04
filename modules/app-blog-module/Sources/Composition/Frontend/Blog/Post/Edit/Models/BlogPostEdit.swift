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

struct BlogPostEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogPostForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1 {
                Span("Edit post")
                AdminPreviewLink(
                    slug: state.form.metadata.slug.value,
                    label: "Preview post"
                ).renderHTML()
            }
            if state.isEdited { P("Post edited successfully.") }
            BlogPostForm(
                state: state.form,
                metadataHref:
                    "/admin/blog/posts/\(state.id)/edit/metadata/\(state.id)/",
                action: "/admin/blog/posts/\(state.id)/edit/",
                submitLabel: "Edit post",
                removeHref: "/admin/blog/posts/\(state.id)/remove/",
                removeLabel: "Remove post"
            )
        }
        .class("cms-section")
    }
}
