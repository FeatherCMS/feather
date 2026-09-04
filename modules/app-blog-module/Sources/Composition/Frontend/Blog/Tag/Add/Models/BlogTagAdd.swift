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

struct BlogTagAdd: Leaf {

    struct State {
        let form: BlogTagForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

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
