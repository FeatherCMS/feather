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

struct BlogTagEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1 {
                Span("Edit tag")
                AdminPreviewLink(
                    slug: state.form.metadata.slug.value,
                    label: "Preview tag"
                ).renderHTML()
            }
            if state.isEdited { P("Tag edited successfully.") }
            BlogTagForm(
                state: state.form,
                metadataHref:
                    "/admin/blog/tags/\(state.id)/edit/metadata/\(state.id)/",
                action: "/admin/blog/tags/\(state.id)/edit/",
                submitLabel: "Edit tag",
                removeHref: "/admin/blog/tags/\(state.id)/remove/",
                removeLabel: "Remove tag"
            )
        }
        .class("cms-section")
    }
}
