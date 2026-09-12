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
        let isEdited: Bool
        let form: BlogAuthorLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Edit blog author link")
            if state.isEdited { P("Blog author link edited successfully.") }
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
