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

struct BlogAuthorEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogAuthorForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1 {
                Span("Edit author")
                AdminPreviewLink(
                    slug: state.form.metadata.slug.value,
                    label: "Preview author"
                ).renderHTML()
            }
            if state.isEdited { P("Author edited successfully.") }
            BlogAuthorForm(
                state: state.form,
                metadataHref:
                    "/admin/blog/authors/\(state.id)/edit/metadata/\(state.id)/",
                action: "/admin/blog/authors/\(state.id)/edit/",
                submitLabel: "Edit author",
                removeHref: "/admin/blog/authors/\(state.id)/remove/",
                removeLabel: "Remove author"
            )
        }
        .class("cms-section")
    }
}
