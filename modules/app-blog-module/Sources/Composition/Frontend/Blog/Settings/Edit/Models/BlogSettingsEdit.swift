import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct BlogSettingsEdit: Component {
    struct State {
        let canEdit: Bool
        let form: BlogSettingsForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(NewAdminBreadcrumb(links: state.breadcrumb))
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Blog settings",
                        description:
                            "Configure public list paths and detail prefixes."
                    )
                )
            )
            if !state.canEdit {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Read-only",
                            message:
                                "You can view these settings, but update permission is required to save changes."
                        ),
                        icon: FeatherIcons.alertCircle()
                    )
                )
            }
            context.build(BlogSettingsForm(state: state.form))
        }
        .class("cms-section")
    }
}
