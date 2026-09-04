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

struct BlogAuthorLinkEdit: Leaf {

    struct State {
        let menuId: String
        let id: String
        let isEdited: Bool
        let form: BlogAuthorLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1("Edit blog author link")
            if state.isEdited { P("Blog author link edited successfully.") }
            BlogAuthorLinkForm(
                state: state.form,
                action:
                    "/admin/blog/authors/\(state.menuId)/links/\(state.id)/edit/",
                submitLabel: "Edit link",
                removeHref:
                    "/admin/blog/authors/\(state.menuId)/links/\(state.id)/remove/",
                removeLabel: "Remove link"
            )
        }
        .class("cms-section")
    }
}
