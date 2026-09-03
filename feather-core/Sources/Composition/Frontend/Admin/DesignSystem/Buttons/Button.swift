import CSS
import HTML
import SGML
import WebStandards

/// The base anchor component for admin design-system buttons.
public struct Button: Component, FlowContent {

    public let label: String
    public let href: String
    public let classes: [String]

    public init(
        _ label: String,
        href: String,
        classes: [String] = []
    ) {
        self.label = label
        self.href = href
        self.classes = classes
    }

    public func selectors() -> [any Selector] {
        for selector in FeatherCSS.Buttons.selectors() {
            selector
        }
    }

    public func content() -> some BasicTag {
        A(label)
            .href(href)
            .class(([("feather-button")] + classes).joined(separator: " "))
    }
}

public struct PrimaryButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(label, href: href, classes: ["feather-button--primary"])
    }
}

public struct SecondaryButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(label, href: href, classes: ["feather-button--secondary"])
    }
}

public struct DestructiveButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(label, href: href, classes: ["feather-button--destructive"])
    }
}

public struct PrimaryActionButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(
            label,
            href: href,
            classes: ["feather-button--primary", "feather-button--action"]
        )
    }
}

public struct SecondaryActionButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(
            label,
            href: href,
            classes: ["feather-button--secondary", "feather-button--action"]
        )
    }
}

public struct DestructiveActionButton: Component, FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> some BasicTag {
        Button(
            label,
            href: href,
            classes: [
                "feather-button--destructive",
                "feather-button--action",
            ]
        )
    }
}
