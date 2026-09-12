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

struct BlogAuthorEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogAuthorForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1 {
                Span("Edit author")
                context.render(
                    AdminPreviewLink(
                        slug: state.form.metadata.slug.value,
                        label: "Preview author"
                    )
                )
            }
            if state.isEdited { P("Author edited successfully.") }
            context.render(
                BlogAuthorForm(
                    state: state.form,
                    metadataHref:
                        "/admin/blog/authors/\(state.id)/edit/metadata/\(state.id)/",
                    action: "/admin/blog/authors/\(state.id)/edit/",
                    submitLabel: "Edit author",
                    removeHref: "/admin/blog/authors/\(state.id)/remove/",
                    removeLabel: "Remove author"
                )
            )
        }
        .class("cms-section")
    }
}
