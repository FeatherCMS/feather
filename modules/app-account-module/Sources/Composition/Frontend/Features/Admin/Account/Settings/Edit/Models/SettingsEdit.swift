import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct SettingsEdit: Component {

    struct State {
        let userID: String?
        let isEdited: Bool
        let canEdit: Bool
        let form: SettingsForm.State
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(AdminBreadcrumb(state: state.breadcrumb))

            H1("Settings")

            if let userID = state.userID {
                context.render(AdminPillTabs(links: [
                    .init(
                        label: "Details",
                        href: "/admin/user/identities/\(userID)/",
                        isCurrent: false
                    ),
                    .init(
                        label: "Profile",
                        href: "/admin/account/users/\(userID)/profile/",
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
                ]))
            }

            if !state.canEdit {
                P(
                    "You can view these settings, but update permission is required to save changes."
                )
            }

            if state.isEdited {
                P("Settings edited successfully.").class("success")
            }

            context.render(SettingsForm(state: state.form))
        }
        .class("cms-section")
    }
}
