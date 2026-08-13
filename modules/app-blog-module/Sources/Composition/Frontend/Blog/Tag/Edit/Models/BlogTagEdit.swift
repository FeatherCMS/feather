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
import WebStandards

struct BlogTagEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1 {
                Span("Edit tag")
                AdminPreviewLink(
                    slug: state.form.metadata.slug.value,
                    label: "Preview tag"
                )
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
