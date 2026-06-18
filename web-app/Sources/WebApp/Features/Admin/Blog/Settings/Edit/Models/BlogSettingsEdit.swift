import HTML
import SGML
import WebStandards

struct BlogSettingsEdit: Component {

    struct State {
        let isEdited: Bool
        let canEdit: Bool
        let form: BlogSettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: state.breadcrumb)

            H1("Settings")
            P(
                "Configure the public list paths and detail prefixes used for blog posts, authors, and tags."
            )
            if !state.canEdit {
                P(
                    "You can view these settings, but create and update permission for variables is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            BlogSettingsForm(state: state.form)
        }
        .class("cms-section")
    }
}
