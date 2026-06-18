import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct BlogTagAdd: Component {

    struct State {
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add tag")
            BlogTagForm(
                state: state.form,
                action: "/admin/blog/tags/add/",
                submitLabel: "Add tag",
                publishLabel: "Publish tag"
            )
        }
        .class("cms-section")
    }
}
