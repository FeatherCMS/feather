import FeatherWebAdmin
import HTML
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Settings.Edit {
    struct Page: Component {

        struct State {
            let canEdit: Bool
            let form: Settings.Edit.Form.Component.State
            let breadcrumb: [AdminBreadcrumb.Link]
            let action: String
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

                context.build(
                    Settings.Edit.Form.Component(
                        state: state.form,
                        action: state.action
                    )
                )
            }
            .class("cms-section")
        }
    }
}
