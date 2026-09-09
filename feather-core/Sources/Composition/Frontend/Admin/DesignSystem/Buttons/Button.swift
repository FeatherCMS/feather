import CSS
import HTML
import SGML
import WebComponents
import WebBuilders
import DOM

/// The base anchor component for admin design-system buttons.
public struct Button: FlowContent {

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

    public func content() -> A {
        A(label)
            .href(href)
            .class(([("feather-button")] + classes).joined(separator: " "))
    }

    public var node: Node { content().node }
}

public struct PrimaryButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(label, href: href, classes: ["feather-button--primary"]).content()
    }

    public var node: Node { content().node }
}

public struct SecondaryButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(label, href: href, classes: ["feather-button--secondary"]).content()
    }

    public var node: Node { content().node }
}

public struct PrimaryGhostButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: ["feather-button--primary-ghost"]
        ).content()
    }

    public var node: Node { content().node }
}

public struct SecondaryGhostButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: ["feather-button--secondary-ghost"]
        ).content()
    }

    public var node: Node { content().node }
}

public struct DestructiveButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(label, href: href, classes: ["feather-button--destructive"]).content()
    }

    public var node: Node { content().node }
}

public struct DisabledButton: FlowContent {

    public let label: String

    public init(_ label: String) {
        self.label = label
    }

    public func content() -> A {
        A(label).class("feather-button feather-button--disabled")
    }

    public var node: Node { content().node }
}

public struct PrimaryActionButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: ["feather-button--primary", "feather-button--action"]
        ).content()
    }

    public var node: Node { content().node }
}

public struct SecondaryActionButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: ["feather-button--secondary", "feather-button--action"]
        ).content()
    }

    public var node: Node { content().node }
}

public struct PrimaryGhostActionButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: [
                "feather-button--primary-ghost",
                "feather-button--action",
            ]
        ).content()
    }

    public var node: Node { content().node }
}

public struct SecondaryGhostActionButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: [
                "feather-button--secondary-ghost",
                "feather-button--action",
            ]
        ).content()
    }

    public var node: Node { content().node }
}

public struct DestructiveActionButton: FlowContent {

    public let label: String
    public let href: String

    public init(_ label: String, href: String) {
        self.label = label
        self.href = href
    }

    public func content() -> A {
        Button(
            label,
            href: href,
            classes: [
                "feather-button--destructive",
                "feather-button--action",
            ]
        ).content()
    }

    public var node: Node { content().node }
}

public struct DisabledActionButton: FlowContent {

    public let label: String

    public init(_ label: String) {
        self.label = label
    }

    public func content() -> A {
        A(label).class("feather-button feather-button--disabled feather-button--action")
    }

    public var node: Node { content().node }
}
