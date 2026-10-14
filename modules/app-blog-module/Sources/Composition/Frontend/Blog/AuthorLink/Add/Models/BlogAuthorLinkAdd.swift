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

struct BlogAuthorLinkAdd: Component {

    struct State {
        let menuId: String
        let form: BlogAuthorLinkForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
                        title: "Add blog author link",
                        description: "Create a link for this author."
                    )
                )
            )
            Div {
                context.build(
                    BlogAuthorLinkForm(
                        state: state.form,
                        action:
                            "/admin/blog/authors/\(state.menuId)/links/add/",
                        submitLabel: "Add link"
                    )
                )
            }
        }
        .class("cms-section")
    }
}
