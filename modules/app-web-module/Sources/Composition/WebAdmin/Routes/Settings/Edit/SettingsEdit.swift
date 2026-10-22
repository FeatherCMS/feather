import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import SGML
import Builders
import Components

struct SettingsEdit: Component {

    struct State {
        let canEdit: Bool
        let form: SettingsForm.State
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(AdminBreadcrumb(links: state.breadcrumb))
            context.build(
                AdminPageHeader(
                    state: .primary(
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

            context.build(SettingsForm(state: state.form))
        }
        .class("cms-section")
    }
}
