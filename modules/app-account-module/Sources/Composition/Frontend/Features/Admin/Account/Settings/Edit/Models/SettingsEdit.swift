import FeatherAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SettingsEdit: Component {

    struct State {
        let userID: String?
        let isEdited: Bool
        let canEdit: Bool
        var form: SettingsForm.State
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(NewAdminBreadcrumb(links: state.breadcrumb))
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: "Settings",
                        description:
                            "Manage application preferences for this account."
                    )
                )
            )

            if let userID = state.userID {
                context.render(
                    NewAdminTabBar(links: [
                        .init(
                            label: "Details",
                            href: "/admin/user/identities/\(userID)/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Settings",
                            href: "/admin/account/users/\(userID)/settings/",
                            isCurrent: true
                        ),
                        .init(
                            label: "Sessions",
                            href: "/admin/user/identities/\(userID)/sessions/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Magic links",
                            href: "/admin/auth/magic-links/?userId=\(userID)",
                            isCurrent: false
                        ),
                    ])
                )
            }

            if !state.canEdit {
                P(
                    "You can view these settings, but update permission is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            let action =
                state.userID.map {
                    AccountAdminRoutes.userSettings(RouterPath($0)).description
                        + "/"
                } ?? AccountAdminRoutes.settings.description + "/"
            context.render(SettingsForm(state: state.form, action: action))
        }
        .class("cms-section")
    }
}
