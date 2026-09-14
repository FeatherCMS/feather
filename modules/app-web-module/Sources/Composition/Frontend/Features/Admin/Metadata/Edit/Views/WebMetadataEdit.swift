import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents

struct WebMetadataEdit: Component {

    struct State {
        let id: String
        let isEdited: Bool
        let form: WebMetadataForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let action: String
        let navigationTabs: [NewAdminPillTab.Link]
        let title: String
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            Div {
                H1 {
                Span(state.title)
                context.render(
                    AdminPreviewLink(
                        slug: state.form.slug.value,
                        label: "Preview page"
                    )
                )
                }
                .class("admin-page-header")
                P("Edit the metadata used when this page is rendered and shared.")
            }
            if state.isEdited { P("Web metadata edited successfully.") }
            context.render(NewAdminPillTab(links: state.navigationTabs))
            context.render(
                WebMetadataForm(
                    state: state.form,
                    action: state.action,
                    submitLabel: "Edit entry"
                )
            )
        }
        .class("cms-section")
    }
}
