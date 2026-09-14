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

struct BlogAuthorLinkEdit: Component {

    struct State {
        let menuId: String
        let id: String
        let form: BlogAuthorLinkForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Edit blog author link",
                        description: "Update this author link."
                    )
                )
            )
            Div {
                context.render(
                    BlogAuthorLinkForm(
                        state: state.form,
                        action:
                            "/admin/blog/authors/\(state.menuId)/links/\(state.id)/edit/",
                        submitLabel: "Edit link",
                        removeHref:
                            "/admin/blog/authors/\(state.menuId)/links/\(state.id)/remove/",
                        removeLabel: "Remove link"
                    )
                )
            }
        }
        .class("cms-section")
    }
}
