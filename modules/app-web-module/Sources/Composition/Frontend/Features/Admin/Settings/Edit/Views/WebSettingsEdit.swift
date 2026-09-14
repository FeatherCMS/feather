import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebSettingsEdit: Component {

    struct State {
        let canEdit: Bool
        let form: WebSettingsForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Settings",
                        description:
                            "Configure website branding, metadata, and code injection."
                    )
                )
            )
            if !state.canEdit {
                P(
                    "You can view these settings, but create and update permission for variables is required to save changes."
                )
            }

            context.render(WebSettingsForm(state: state.form))
        }
        .class("cms-section")
    }
}
