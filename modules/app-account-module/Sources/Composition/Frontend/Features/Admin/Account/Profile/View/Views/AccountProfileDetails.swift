import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import WebBuilders
import WebComponents

struct AccountProfileDetails: Component {
    struct State {
        let profile: AdminViewAccountProfileModel
        let canEdit: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout RenderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if state.canEdit {
            actions.append(
                .init(
                    label: "Edit profile",
                    href: "/admin/account/profile/edit/",
                    style: .primary
                )
            )
        }
        return context.render(
            NewAdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Profile",
                    description: "Inspect the current administrator profile."
                ),
                fields: [
                    .init(label: "ID", value: state.profile.id),
                    .init(
                        label: "Profile image",
                        value: state.profile.profileImageAssetId ?? "—"
                    ),
                    .init(
                        label: "First name",
                        value: state.profile.firstName?.emptyToNil ?? "—"
                    ),
                    .init(
                        label: "Last name",
                        value: state.profile.lastName?.emptyToNil ?? "—"
                    ),
                    .init(
                        label: "Roles",
                        value: state.profile.roles.isEmpty
                            ? "—" : state.profile.roles.joined(separator: ", ")
                    ),
                    .init(
                        label: "Permissions",
                        value: state.profile.permissions.isEmpty
                            ? "—"
                            : state.profile.permissions.joined(separator: ", ")
                    ),
                ],
                actions: actions
            )
        )
    }
}
