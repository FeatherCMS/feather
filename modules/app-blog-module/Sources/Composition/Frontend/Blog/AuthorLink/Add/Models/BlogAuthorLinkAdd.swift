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

struct BlogAuthorLinkAdd: Component {

    struct State {
        let menuId: String
        let form: BlogAuthorLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Add blog author link")
            BlogAuthorLinkForm(
                state: state.form,
                action: "/admin/blog/authors/\(state.menuId)/links/add/",
                submitLabel: "Add link"
            )
        }
        .class("cms-section")
    }
}
