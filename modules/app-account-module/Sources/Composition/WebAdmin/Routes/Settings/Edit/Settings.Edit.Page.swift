import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension Settings.Edit {
    struct Page: Component {
        let routes: Settings.Router.Routes

        struct State {
            let userID: String?
            let canEdit: Bool
            var form: Form.Component.State
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
                                href: routes.userIdentityPath(userID),
                                isCurrent: false
                            ),
                            .init(
                                label: "Settings",
                                href: routes.userSettingsPath(userID) + "/",
                                isCurrent: true
                            ),
                            .init(
                                label: "Sessions",
                                href: routes.userSessionsPath(userID),
                                isCurrent: false
                            ),
                            .init(
                                label: "Magic links",
                                href: routes.magicLinksPath(userID),
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

                let action = state.userID.map { routes.userSettingsPath($0) }
                    ?? routes.settings.path
                context.build(
                    Form.Component(
                        state: state.form,
                        action: action
                    )
                )
            }
            .class("cms-section")
        }
    }
}
