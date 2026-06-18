import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogAuthorEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogAuthorForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit author")
            if state.isEdited { P("Author edited successfully.") }
            BlogAuthorForm(
                state: state.form,
                action: "/admin/blog/authors/\(state.id)/edit/",
                submitLabel: "Edit author",
                removeHref: "/admin/blog/authors/\(state.id)/remove/",
                removeLabel: "Remove author"
            )
        }
        .class("cms-section")
    }
}
