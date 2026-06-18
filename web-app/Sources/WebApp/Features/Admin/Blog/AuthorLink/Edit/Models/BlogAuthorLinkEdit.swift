import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorLinkEdit: Component {

    struct State {
        let menuId: String
        let id: String
        let isEdited: Bool
        let form: BlogAuthorLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

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
