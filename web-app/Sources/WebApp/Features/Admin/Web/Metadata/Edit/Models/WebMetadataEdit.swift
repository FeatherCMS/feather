import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct WebMetadataEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMetadataForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Edit web metadata")
            if state.isEdited { P("Web metadata edited successfully.") }
            WebMetadataForm(
                state: state.form,
                action: "/admin/web/metadata/\(state.id)/edit/",
                submitLabel: "Edit entry"
            )
        }
        .class("cms-section")
    }
}
