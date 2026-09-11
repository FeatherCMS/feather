import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct WebSettingsEdit: Component {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: WebSettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Settings")
            P(
                "Configure the website branding, metadata, and global CSS or JavaScript used by the public web frontend."
            )
            if !state.canEdit {
                P(
                    "You can view these settings, but create and update permission for variables is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            context.render(WebSettingsForm(state: state.form))
        }
        .class("cms-section")
    }
}
