import FeatherAdmin
import Hummingbird

enum AccountAdminRoutes {
    static let admin = RouterPath("admin")
    static let account = admin.appendingPath(RouterPath("account"))
    static let profile = account.appendingPath(RouterPath("profile"))
    static let profileEdit = profile.appendingPath(RouterPath("edit"))
    static let profileImage = profile.appendingPath(RouterPath("image"))
    static let settings = account.appendingPath(RouterPath("settings"))
    static let userSettingsPattern =
        account
        .appendingPath(RouterPath("users"))
        .appendingPath(RouterPath("{userId}"))
        .appendingPath(RouterPath("settings"))

    static func userSettings(_ id: RouterPath) -> RouterPath {
        account
            .appendingPath(RouterPath("users"))
            .appendingPath(id)
            .appendingPath(RouterPath("settings"))
    }

    static let invitations = account.appendingPath(
        RouterPath("invitations")
    )
    static let invitationAdd = invitations.appendingPath(RouterPath("add"))
    static let invitationRemoveBulk = invitations.appendingPath(
        RouterPath("remove")
    )

    static let breadcrumb: [NewAdminBreadcrumb.Link] = [
        .init(label: "Admin", link: "/admin/"),
        .init(label: "Account", link: "/admin/account/"),
    ]

    static let profileBreadcrumb: [NewAdminBreadcrumb.Link] =
        breadcrumb + [
            .init(label: "Profile", link: profile.description)
        ]

    static let settingsBreadcrumb: [NewAdminBreadcrumb.Link] =
        breadcrumb + [
            .init(label: "Settings", link: settings.description)
        ]

    static let invitationBreadcrumb: [NewAdminBreadcrumb.Link] =
        breadcrumb + [
            .init(label: "Invitations", link: invitations.description)
        ]

    static func invitationDetailsBreadcrumb(
        _ id: RouterPath
    ) -> [NewAdminBreadcrumb.Link] {
        invitationBreadcrumb + [
            .init(label: "Details", link: invitationDetails(id).description)
        ]
    }

    static func invitationEditBreadcrumb(
        _ id: RouterPath
    ) -> [NewAdminBreadcrumb.Link] {
        invitationDetailsBreadcrumb(id) + [
            .init(label: "Edit", link: invitationEdit(id).description)
        ]
    }

    static func invitationRemoveBreadcrumb(
        _ id: RouterPath
    ) -> [NewAdminBreadcrumb.Link] {
        invitationBreadcrumb + [
            .init(label: "Remove", link: invitationRemove(id).description)
        ]
    }

    static func invitationDetails(_ id: RouterPath) -> RouterPath {
        invitations.appendingPath(id)
    }

    static func invitationEdit(_ id: RouterPath) -> RouterPath {
        invitationDetails(id).appendingPath(RouterPath("edit"))
    }

    static func invitationRemove(_ id: RouterPath) -> RouterPath {
        invitationDetails(id).appendingPath(RouterPath("remove"))
    }

    static func invitationResend(_ id: RouterPath) -> RouterPath {
        invitationDetails(id).appendingPath(RouterPath("resend"))
    }

    static let invitationDetailsPattern = invitationDetails(RouterPath("{id}"))
    static let invitationEditPattern = invitationEdit(RouterPath("{id}"))
    static let invitationRemovePattern = invitationRemove(RouterPath("{id}"))
    static let invitationResendPattern = invitationResend(RouterPath("{id}"))
}
