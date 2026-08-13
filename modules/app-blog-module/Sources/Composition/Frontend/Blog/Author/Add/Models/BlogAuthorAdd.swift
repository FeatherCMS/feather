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
import WebStandards

struct BlogAuthorAdd: Component {

    struct State {
        let form: BlogAuthorForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Add author")
            BlogAuthorForm(
                state: state.form,
                action: "/admin/blog/authors/add/",
                submitLabel: "Add author",
                publishLabel: "Publish author"
            )
        }
        .class("cms-section")
    }
}
