public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

/// A fixed-size image cell for admin lists and tables.
public struct AdminImageCell: Component {

    public enum Size: Sendable {
        case square
        case cover
        case circular

        fileprivate var className: String {
            switch self {
            case .square:
                "admin-image-cell--square"
            case .cover:
                "admin-image-cell--cover"
            case .circular:
                "admin-image-cell--circular"
            }
        }
    }

    public let imageURL: String?
    public let alt: String
    public let size: Size

    public init(
        imageURL: String?,
        alt: String = "",
        size: Size = .square
    ) {
        self.imageURL = imageURL
        self.alt = alt
        self.size = size
    }

    public func selectors() -> [any CSS.Selector] {
        [
            Class("admin-image-cell") {
                Display(.grid)
                UnsafeRawProperty(name: "place-items", value: "center")
                FlexShrink(0)
                BoxSizing(.borderBox)
                Overflow(.hidden)
                BorderRadius(10.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                Background(
                    .variable(TokenKey.Colors.Materials.Secondary.tint)
                )
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
            Class("admin-image-cell--square") {
                Width(56.px)
                Height(56.px)
            },
            Class("admin-image-cell--cover") {
                Width(100.px)
                Height(56.px)
            },
            Class("admin-image-cell--circular") {
                Width(56.px)
                Height(56.px)
                BorderRadius(50.percent)
            },
            Custom(".admin-image-cell img") {
                Display(.block)
                Width(100.percent)
                Height(100.percent)
                ObjectFit(.cover)
                Margin(0)
            },
            Custom(".admin-image-cell > span") {
                FontSize(0.9.rem)
                Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Div {
        Div {
            if let imageURL {
                Img(src: imageURL, alt: alt)
            }
            else {
                Span("-").ariaHidden("true")
            }
        }
        .class("admin-image-cell", size.className)
    }
}
