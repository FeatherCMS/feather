import AccountModule
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct SettingsEdit: Component {
    let routes: Settings.Router.Routes

    struct State {
        let userID: String?
        let canEdit: Bool
        var form: SettingsForm.State
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
                            "Manage application preferences for this account."
                    )
                )
            )

            if let userID = state.userID {
                context.build(
                    AdminTabBar(links: [
                        .init(
                            label: "Details",
                            href: "/admin/user/identities/\(userID)/",
                            isCurrent: false
                        ),
                        .init(
                            label: "Settings",
                            href: routes.userSettings(userID) + "/",
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

            let action =
                state.userID.map {
                    routes.userSettings($0)
                        + "/"
                } ?? routes.settings.path + "/"
            context.build(SettingsForm(state: state.form, action: action))
        }
        .class("cms-section")
    }
}
import FeatherWebShared
