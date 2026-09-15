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
        let form: BlogTagForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit tag",
                        description: "Update this blog tag."
                    )
                )
            )
            context.build(
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
