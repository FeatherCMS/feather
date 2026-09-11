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
        let breadcrumb: AdminBreadcrumb.State
        let action: String
        let navigationTabs: [AdminPillTabs.Link]
        let title: String
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1 {
                Span(state.title)
                context.render(
                    AdminPreviewLink(
                        slug: state.form.slug.value,
                        label: "Preview page"
                    )
                )
            }
            if state.isEdited { P("Web metadata edited successfully.") }
            context.render(AdminPillTabs(links: state.navigationTabs))
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
