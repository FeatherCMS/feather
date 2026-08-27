import FeatherAdmin
import HTML
import SGML
import WebStandards

struct AccountProfileEdit: Component {
    let userID: String
    let state: AccountProfileForm.State
    let isEdited: Bool

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(
                state: .init(
                    links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Account", link: "/admin/account/"),
                        .init(label: "Users", link: "/admin/user/identities/"),
                        .init(label: "Profile", link: state.action),
                    ]
                )
            )
            H1("Profile")
            AdminPillTabs(links: [
                .init(label: "Details", href: "/admin/user/identities/\(userID)/", isCurrent: false),
                .init(label: "Profile", href: state.action, isCurrent: true),
                .init(label: "Settings", href: "/admin/account/users/\(userID)/settings/", isCurrent: false),
                .init(label: "Sessions", href: "/admin/user/identities/\(userID)/sessions/", isCurrent: false),
                .init(label: "Magic links", href: "/admin/auth/magic-links/?userId=\(userID)", isCurrent: false),
            ])
            if isEdited {
                P("Profile edited successfully.").class("success")
            }
            AccountProfileForm(state: state)
        }.class("cms-section")
    }
}
