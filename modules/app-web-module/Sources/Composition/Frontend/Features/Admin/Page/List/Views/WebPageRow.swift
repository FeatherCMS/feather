import FeatherAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebContracts

struct WebPageRow: Component {
    let page: AdminListWebPageItemModel
    let permissions: AdminListActions
    let canEdit: Bool
    let returnTo: String

    func html(context: inout BuilderContext) -> Tr {
        Tr {
            if permissions.allows(WebPermissions.Pages.delete) {
                context.build(AdminListRowCheckbox(id: page.id))
            }
            titleCell(context: &context)
            statusCell(context: &context)
            Td(
                page.metadata.publicationDate.map {
                    DateFormatting.formatUnixTimestamp($0)
                } ?? "-"
            )
            .data("label", "Publication")
            Td {
                context.build(
                    AdminChip(
                        label: page.availability.label,
                        color: page.availability.color
                    )
                )
            }
            .data("label", "Availability")
            context.build(
                AdminListRowActions(
                    label: "Actions",
                    actions: [
                        .init(
                            "View",
                            href: WebPageRoutes.details(RouterPath(page.id))
                                .description,
                            style: .ghost(.primary),
                            permission: WebPermissions.Pages.read
                        ),
                        .init(
                            "Edit",
                            href: WebPageRoutes.edit(RouterPath(page.id))
                                .description,
                            style: .ghost(.secondary),
                            permission: WebPermissions.Pages.update
                        ),
                    ],
                    permissions: permissions
                )
            )
        }
    }

    private func titleCell(context: inout BuilderContext) -> Td {
        Td {
            Span {
                Span(page.title)
                if let previewPath = previewPath {
                    context.build(
                        AdminPreviewLink(
                            href: previewPath,
                            label: "Preview \(page.title)"
                        )
                    )
                }
            }
        }
        .data("label", "Title")
        .data("remove-label", "true")
    }

    private func statusCell(context: inout BuilderContext) -> Td {
        Td {
            if canEdit {
                context.build(
                    AdminStatusSelectField(
                        formID: "web-page-status-\(page.id)",
                        selectedStatus: page.metadata.normalizedStatus
                    )
                )
            }
            else {
                Span(page.metadata.status.capitalized)
            }
        }
        .data("label", "Status")
    }

    private var previewPath: String? {
        let slug = page.metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }

}
