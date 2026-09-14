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
        let form: BlogAuthorForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit author",
                        description: "Update this blog author."
                    )
                )
            )
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
