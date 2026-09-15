import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaProcessorDetailsView: Component {
    let item: Components.Schemas.MediaProcessorDetailSchema
    let permissions: NewAdminListActions

    func html(context: inout BuilderContext) -> some BasicTag {
        context.build(
            NewAdminDetailView(
                breadcrumb: MediaProcessorRoutes.breadcrumb,
                pageHeader: .init(
                    title: "Processor details",
                    description: "Review this media processing rule."
                ),
                fields: [
                    .init(label: "ID", value: item.id),
                    .init(label: "File suffix", value: item.name),
                    .init(
                        label: "Match extensions",
                        value: item.matchExtensions
                    ),
                    .init(
                        label: "Command template",
                        value: item.commandTemplate
                    ),
                    .init(
                        label: "Active",
                        value: item.isActive ? "Yes" : "No"
                    ),
                ],
                actions: actions()
            )
        )
    }

    private func actions() -> [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if permissions.allows(MediaPermissions.Processors.update) {
            result.append(
                .init(
                    label: "Edit",
                    href:
                        MediaProcessorRoutes.edit(
                            RouterPath(item.id)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if permissions.allows(MediaPermissions.Processors.delete) {
            result.append(
                .init(
                    label: "Remove",
                    href:
                        MediaProcessorRoutes.remove(
                            RouterPath(item.id)
                        )
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }
}
