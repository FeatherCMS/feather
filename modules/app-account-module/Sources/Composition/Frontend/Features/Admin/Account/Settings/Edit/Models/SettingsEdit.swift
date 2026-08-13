import FeatherAdmin
import HTML
import SGML
import WebStandards

struct SettingsEdit: Component {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: SettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Settings")

            if !state.canEdit {
                P(
                    "You can view these settings, but update permission is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            SettingsForm(state: state.form)
        }
        .class("cms-section")
    }
}
