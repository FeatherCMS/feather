import CSS
import Foundation
import HTML
import SGML
import WebComponents
import WebBuilders

public struct AdminPreviewLink: Leaf {
    public let slug: String?
    public let label: String

    public init(slug: String?, label: String) {
        self.slug = slug
        self.label = label
    }

    public func selectors() -> [any CSS.Selector] {
        [Class("admin-preview-link") {
            Display(.inlineFlex)
            AlignItems(.center)
            JustifyContent(.center)
            Width(1.25.rem)
            Height(1.25.rem)
            MarginLeft(0.4.rem)
            VerticalAlign(.middle)
        }]
    }

    public func html() -> A {
        var link = A {
            Icon(svg: FeatherIcons.externalLink()).html()
        }
        if let slug = normalizedSlug {
            link = link
                .href("/\(slug)/")
                .target(.blank)
                .ariaLabel(label)
                .class("admin-preview-link")
        }
        return link
    }

    private var normalizedSlug: String? {
        guard let slug else {
            return nil
        }
        let value = slug.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
