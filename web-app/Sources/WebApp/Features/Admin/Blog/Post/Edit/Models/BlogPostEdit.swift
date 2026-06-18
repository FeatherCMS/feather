import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogPostEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: BlogPostForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit post")
            if state.isEdited { P("Post edited successfully.") }
            BlogPostForm(
                state: state.form,
                action: "/admin/blog/posts/\(state.id)/edit/",
                submitLabel: "Edit post",
                removeHref: "/admin/blog/posts/\(state.id)/remove/",
                removeLabel: "Remove post"
            )
        }
        .class("cms-section")
    }
}
