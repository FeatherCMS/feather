import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebComponents
import WebBuilders

struct WebMetadataEdit: Leaf {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMetadataForm.State
        let breadcrumb: AdminBreadcrumb.State
        let action: String
        let navigationTabs: [AdminPillTabs.Link]
        let title: String
    }

    let state: State

    func renderHTML() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).renderHTML()

            H1 {
                Span(state.title)
                AdminPreviewLink(
                    slug: state.form.slug.value,
                    label: "Preview page"
                ).renderHTML()
            }
            if state.isEdited { P("Web metadata edited successfully.") }
            AdminPillTabs(links: state.navigationTabs).renderHTML()
            WebMetadataForm(
                state: state.form,
                action: state.action,
                submitLabel: "Edit entry"
            ).renderHTML()
        }
        .class("cms-section")
    }
}
