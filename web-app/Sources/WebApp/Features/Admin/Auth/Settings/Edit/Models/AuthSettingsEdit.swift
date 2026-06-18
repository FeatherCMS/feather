import HTML
import SGML
import WebStandards

struct AuthSettingsEdit: Component {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: AuthSettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Settings")
            P(
                "These settings are placeholder inputs for future localization work and table preferences."
            )
            if !state.canEdit {
                P(
                    "You can view these settings, but update permission is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            AuthSettingsForm(state: state.form)
        }
        .class("cms-section")
    }
}
