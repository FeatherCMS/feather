import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorLinkAdd: Component {

    struct State {
        let menuId: String
        let form: BlogAuthorLinkForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

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
