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

struct BlogTagEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1 {
                Span("Edit tag")
                context.render(
                    AdminPreviewLink(
                        slug: state.form.metadata.slug.value,
                        label: "Preview tag"
                    )
                )
            }
            if state.isEdited { P("Tag edited successfully.") }
            context.render(
                BlogTagForm(
                    state: state.form,
                    metadataHref:
                        "/admin/blog/tags/\(state.id)/edit/metadata/\(state.id)/",
                    action: "/admin/blog/tags/\(state.id)/edit/",
                    submitLabel: "Edit tag",
                    removeHref: "/admin/blog/tags/\(state.id)/remove/",
                    removeLabel: "Remove tag"
                )
            )
        }
        .class("cms-section")
    }
}
