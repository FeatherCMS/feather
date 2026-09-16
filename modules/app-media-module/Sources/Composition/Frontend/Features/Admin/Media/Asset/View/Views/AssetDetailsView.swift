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

struct AssetDetailsView: Component {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
    let permissions: NewAdminListActions

    private func previewLink(
        for storageKey: String,
        isVariant: Bool
    ) -> String {
        NewAdminMediaAsset.mediaURL(
            storageKey: storageKey,
            isVariant: isVariant
        )
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
            )
            context.build(
                NewAdminPageHeader(
                    state: .init(
                        title: "Media asset details",
                        description:
                            "Review asset metadata and generated variants."
                    )
                )
            )
            context.build(
                NewAdminDetailField(label: "ID", value: item.id)
            )
            context.build(
                NewAdminDetailField(
                    label: "Storage key",
                    value: item.storageKey
                )
            )
            context.build(
                NewAdminDetailField(label: "Type", value: item._type)
            )
            context.build(
                NewAdminDetailField(label: "Status", value: item.status)
            )
            context.build(
                NewAdminDetailField(
                    label: "Size bytes",
                    value: "\(item.sizeBytes)"
                )
            )
            if let title = item.title {
                context.build(
                    NewAdminDetailField(label: "Title", value: title)
                )
            }
            if let altText = item.altText {
                context.build(
                    NewAdminDetailField(label: "Alt text", value: altText)
                )
            }
            context.build(
                NewAdminButton(
                    "Open original",
                    href: previewLink(for: item.storageKey, isVariant: false),
                    style: .secondary
                )
            )
            if variants.isEmpty {
                P("No generated variants linked to this asset yet.")
            }
            else {
                H2("Associated variants")
                context.build(
                    NewAdminListShell(
                        layout: .init(
                            name: "media-asset-variants",
                            columns: [
                                .fraction(1),
                                .fixed(100),
                                .fraction(2),
                                .fixed(120),
                            ]
                        ),
                        hasSelection: false,
                        table: Table {
                            Thead {
                                Tr {
                                    Th("Name")
                                    Th("Type")
                                    Th("Storage key")
                                    Th("Preview")
                                }
                            }
                            Tbody {
                                for variant in variants {
                                    Tr {
                                        Td(variant.name)
                                        Td(variant._type)
                                        Td(variant.storageKey)
                                        Td {
                                            context.build(
                                                NewAdminRowButton(
                                                    "Preview",
                                                    href: previewLink(
                                                        for: variant.storageKey,
                                                        isVariant: true
                                                    ),
                                                    style: .ghost(.primary)
                                                )
                                            )
                                        }
                                        .data("label", "Preview")
                                    }
                                }
                            }
                        }
                        .class("cms-table")
                    )
                )
            }
            Div {
                if permissions.allows(MediaPermissions.Assets.update) {
                    context.build(
                        NewAdminButton(
                            "Edit",
                            href:
                                MediaAssetRoutes.edit(
                                    RouterPath(item.id)
                                )
                                .description
                        )
                    )
                }
                if permissions.allows(MediaPermissions.Assets.delete) {
                    context.build(
                        NewAdminButton(
                            "Remove",
                            href:
                                MediaAssetRoutes.remove(
                                    RouterPath(item.id)
                                )
                                .description,
                            style: .destructive
                        )
                    )
                }
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
