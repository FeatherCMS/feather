import FeatherAdmin
import FeatherContracts
import Foundation
import HTML
import Hummingbird
import SGML
import WebAdminAPI
import WebBuilders
import WebComponents
import WebContracts

struct WebMetadataRow: Component {
    let metadata: Components.Schemas.WebMetadataListItemSchema
    let permissions: NewAdminListActions

    func html(context: inout RenderContext) -> Tr {
        Tr {
            Td(metadata.slug).data("label", "Slug")
            Td(metadata.referenceType ?? "—").data("label", "Reference type")
            Td(metadata.status.capitalized).data("label", "Status")
            Td(format(metadata.publicationDate)).data("label", "Publication")
            Td(format(metadata.expirationDate)).data("label", "Expiration")
            context.render(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init("View", href: WebMetadataRoutes.details(RouterPath(metadata.id)).description, style: .ghost(.primary), permission: WebPermissions.Metadata.read),
                        .init("Edit", href: WebMetadataRoutes.edit(RouterPath(metadata.id)).description, style: .ghost(.secondary), permission: WebPermissions.Metadata.update),
                    ],
                    permissions: permissions
                )
            )
        }
    }

    private func format(_ timestamp: Double?) -> String {
        guard let timestamp else { return "—" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
