import CSS
import Foundation
import HTML
import SGML
import WebStandards

public struct AdminPreviewLink: Component, PhrasingContent {
    public let slug: String?
    public let label: String

    public init(slug: String?, label: String) {
        self.slug = slug
        self.label = label
    }

    public func selectors() -> [any CSS.Selector] {
        Class("admin-preview-link") {
            Display(.inlineFlex)
            AlignItems(.center)
            JustifyContent(.center)
            Width(1.25.rem)
            Height(1.25.rem)
            MarginLeft(0.4.rem)
            VerticalAlign(.middle)
        }
    }

    public func content() -> some BasicTag {
        if let slug = normalizedSlug {
            A {
                Icon(svg: FeatherIcons.externalLink())
            }
            .href("/\(slug)/")
            .target(.blank)
            .ariaLabel(label)
            .class("admin-preview-link")
        }
    }

    private var normalizedSlug: String? {
        guard let slug else {
            return nil
        }
        let value = slug.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
