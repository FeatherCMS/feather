import FeatherAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct WebSettingsEdit: Leaf {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: WebSettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb).html()

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

            WebSettingsForm(state: state.form).html()
        }
        .class("cms-section")
    }
}
