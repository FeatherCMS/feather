import FeatherAdmin
import FeatherContracts
import HTML
import MediaContracts
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorRow: Component {
    struct State: Sendable {
        let id: String
        let fileSuffix: String
        let matchExtensions: String
        let actions: [NewAdminListRowActions.Action]

        init(
            item: Components.Schemas.MediaProcessorListItemSchema,
            returnTo: String
        ) {
            self.id = item.id
            self.fileSuffix = item.name
            self.matchExtensions = item.matchExtensions
            self.actions = [
                .init(
                    "View",
                    href: MediaProcessorRoutes.details(RouterPath(item.id))
                        .description,
                    style: .ghost(.primary),
                    permission: MediaPermissions.Processors.read
                ),
                .init(
                    "Edit",
                    href: MediaProcessorRoutes.edit(RouterPath(item.id))
                        .description,
                    style: .ghost(.secondary),
                    permission: MediaPermissions.Processors.update
                ),
                .init(
                    "Remove",
                    href: NewAdminLocation.remove(
                        path: MediaProcessorRoutes.remove.description,
                        ids: [item.id],
                        returnTo: returnTo
                    ),
                    style: .destructive,
                    permission: MediaPermissions.Processors.delete
                ),
            ]
        }
    }

    let state: State
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            if permissions.allows(MediaPermissions.Processors.delete) {
                context.render(NewAdminListRowCheckbox(id: state.id))
            }
            Td(state.fileSuffix)
                .data("label", "File suffix")
            Td(
                state.matchExtensions.emptyToNil == nil
                    ? "—" : state.matchExtensions
            )
            .data("label", "Match extensions")
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: state.actions,
                    permissions: permissions
                )
            )
        }
    }
}
