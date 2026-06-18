import AdminOpenAPI
import Foundation
import HTML
import SGML
import WebStandards

struct AssetDetailsView: Component {
    let item: Components.Schemas.MediaAssetDetailSchema
    let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
    let breadcrumb: AdminBreadcrumb.State
    let canEdit: Bool
    let canRemove: Bool

    private func compactStorageKey(
        _ key: String
    ) -> String {
        let prefix = "media/assets/"
        guard key.hasPrefix(prefix) else { return key }
        return String(key.dropFirst(prefix.count))
    }

    private func previewLink(
        for storageKey: String,
        isVariant: Bool
    ) -> String {
        let normalizedKey = compactStorageKey(storageKey)
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        let encoded =
            normalizedKey.addingPercentEncoding(withAllowedCharacters: allowed)
            ?? normalizedKey
        let prefix = isVariant ? "/media/variants/" : "/media/assets/"
        return
            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)\(prefix)\(encoded)"
    }

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: breadcrumb)
            H1("Media asset details")
            AdminDetailsField(label: "ID", value: item.id)
            AdminDetailsField(label: "Storage key", value: item.storageKey)
            AdminDetailsField(label: "Type", value: item._type)
            AdminDetailsField(label: "Status", value: item.status)
            AdminDetailsField(label: "Size bytes", value: "\(item.sizeBytes)")
            Div {
                P("Preview original")
                    .class("admin-details-field__label")
                P {
                    A("Preview original")
                        .href(
                            previewLink(for: item.storageKey, isVariant: false)
                        )
                        .setAttribute(name: "target", value: "_blank")
                }
                .class("admin-details-field__value")
            }
            .class("admin-details-field")
            if let title = item.title {
                AdminDetailsField(label: "Title", value: title)
            }
            if let altText = item.altText {
                AdminDetailsField(label: "Alt text", value: altText)
            }
            if variants.isEmpty {
                P("No generated variants linked to this asset yet.")
            }
            else {
                H2("Associated variants")
                ListTableShell(
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
                                        A("Preview")
                                            .href(
                                                previewLink(
                                                    for: variant.storageKey,
                                                    isVariant: true
                                                )
                                            )
                                            .setAttribute(
                                                name: "target",
                                                value: "_blank"
                                            )
                                            .class("row-btn")
                                    }
                                }
                            }
                        }
                    }
                    .class("cms-table")
                )
            }
            Div {
                if canEdit {
                    AdminNavigationButton(
                        "Edit asset",
                        href: "/admin/media/assets/\(item.id)/edit/"
                    )
                }
                if canRemove {
                    AdminNavigationButton(
                        "Remove asset",
                        href: "/admin/media/assets/\(item.id)/remove/",
                        classes: ["danger"]
                    )
                }
            }
            .class("button-row", "admin-detail-actions")
        }
        .class("cms-section")
    }
}
