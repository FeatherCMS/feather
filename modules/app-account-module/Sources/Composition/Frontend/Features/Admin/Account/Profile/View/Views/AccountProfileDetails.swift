import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import WebComponents

struct AccountProfileDetails: Component {
    struct State {
        let profile: AdminViewAccountProfileModel
        let canEdit: Bool
        let breadcrumb: [NewAdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        var actions: [NewAdminDetailView.Action] = []
        if state.canEdit {
            actions.append(
                .init(
                    label: "Edit profile",
                    href: AccountAdminRoutes.profileEdit.description,
                    style: .primary
                )
            )
        }
        return context.build(
            NewAdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .init(
                    title: "Profile",
                    description: "Inspect the current administrator profile."
                ),
                fields: [
                    state.profile.profileImageAsset.flatMap { asset in
                        (asset.previewURL ?? asset.originalURL).isEmpty
                            ? nil
                            : .init(
                                label: "Profile image",
                                imageURL: NewAdminMediaAsset.mediaURL(
                                    path: asset.previewURL ?? asset.originalURL
                                )
                            )
                    } ?? .init(label: "Profile image", value: "—"),
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
                ],
                actions: actions
            )
        )
    }
}
