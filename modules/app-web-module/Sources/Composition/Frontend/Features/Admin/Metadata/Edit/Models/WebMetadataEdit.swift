import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebStandards

struct WebMetadataEdit: Component {

    struct AdminWebMetadataTabs: Component, FlowContent {
        let links: [AdminPillTabs.Link]

        func content() -> some BasicTag {
            AdminPillTabs(links: links).content()
        }
    }

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

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1 {
                Span(state.title)
                AdminPreviewLink(
                    slug: state.form.slug.value,
                    label: "Preview page"
                )
            }
            if state.isEdited { P("Web metadata edited successfully.") }
            AdminWebMetadataTabs(links: state.navigationTabs)
            WebMetadataForm(
                state: state.form,
                action: state.action,
                submitLabel: "Edit entry"
            )
        }
        .class("cms-section")
    }
}
