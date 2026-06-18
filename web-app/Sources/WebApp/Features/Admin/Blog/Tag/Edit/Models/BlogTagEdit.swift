import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogTagEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit tag")
            if state.isEdited { P("Tag edited successfully.") }
            BlogTagForm(
                state: state.form,
                action: "/admin/blog/tags/\(state.id)/edit/",
                submitLabel: "Edit tag",
                removeHref: "/admin/blog/tags/\(state.id)/remove/",
                removeLabel: "Remove tag"
            )
        }
        .class("cms-section")
    }
}
