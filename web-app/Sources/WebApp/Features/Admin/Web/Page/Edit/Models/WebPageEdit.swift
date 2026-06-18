import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebPageEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebPageForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit page")
            if state.isEdited { P("Page edited successfully.") }
            WebPageForm(
                state: state.form,
                action: "/admin/web/pages/\(state.id)/edit/",
                submitLabel: "Edit page",
                removeHref: "/admin/web/pages/\(state.id)/remove/",
                removeLabel: "Remove page"
            )
        }
        .class("cms-section")
    }
}
