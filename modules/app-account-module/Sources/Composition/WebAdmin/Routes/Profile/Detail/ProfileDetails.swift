import AccountModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import WebComponents

struct ProfileDetails: Component {
    let routes: Profile.Router.Routes
    struct State {
        let profile: Profile.Detail.Model
        let canEdit: Bool
        let breadcrumb: [AdminBreadcrumb.Link]
    }

    let state: State

    func html(context: inout BuilderContext) -> Section {
        var actions: [AdminDetailView.Action] = []
        if state.canEdit {
            actions.append(
                .init(
                    label: "Edit profile",
                    href: routes.profileEdit.path,
                    style: .primary
                )
            )
        }
        return context.build(
            AdminDetailView(
                breadcrumb: state.breadcrumb,
                pageHeader: .primary(
                    title: "Profile",
                    description: "Inspect the current administrator profile."
                ),
                fields: [
                    state.profile.profileImageAsset.flatMap { asset in
                        (asset.previewURL ?? asset.originalURL).isEmpty
                            ? nil
                            : .init(
                                label: "Profile image",
                                imageURL: AdminMediaAsset.mediaURL(
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
