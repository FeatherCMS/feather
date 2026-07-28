import HTML
import SGML
import WebStandards

struct AccountSettingsEdit: Component {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: AccountSettingsForm.State
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

            AccountSettingsForm(state: state.form)
        }
        .class("cms-section")
    }
}
