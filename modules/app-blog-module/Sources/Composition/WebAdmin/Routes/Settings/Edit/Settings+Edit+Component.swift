import BlogModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Settings.Edit {
    struct Component: WebComponents.Component {
        struct State {
            let canEdit: Bool
            let form: Settings.Edit.Form.State
            let breadcrumb: [AdminBreadcrumb.Link]
        }
        let state: State
        let routes: Settings.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(AdminBreadcrumb(links: state.breadcrumb))
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Blog settings",
                            description:
                                "Configure public list paths and detail prefixes."
                        )
                    )
                )
                if !state.canEdit {
                    context.build(
                        AdminStatusView(
                            state: .init(
                                title: "Read-only",
                                message:
                                    "You can view these settings, but update permission is required to save changes."
                            ),
                            icon: FeatherIcons.alertCircle()
                        )
                    )
                }
                context.build(
                    Settings.Edit.Form(
                        state: state.form,
                        action: routes.settings.path
                    )
                )
            }
            .class("cms-section")
        }
    }
}
import FeatherWebShared
