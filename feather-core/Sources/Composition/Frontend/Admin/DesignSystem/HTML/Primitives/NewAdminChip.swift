import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

public struct NewAdminChip: Component {

    public enum ColorName: String, Sendable {
        case red
        case blue
        case green
        case yellow
        case orange
        case purple
    }

    public let label: String
    public let color: ColorName

    public init(
        label: String,
        color: ColorName
    ) {
        self.label = label
        self.color = color
    }

    public func selectors() -> [any Selector] {
        [
            Class("new-admin-chip") {
                Display(.inlineFlex)
                AlignItems(.center)
                BoxSizing(.borderBox)
                Border(1.px, .solid)
                BorderRadius(999.px)
                Padding(vertical: 4.px, horizontal: 9.px)
                FontSize(0.78.rem)
                FontWeight(.number(600))
                LineHeight(1.2)
                WhiteSpace(.nowrap)
            },
            Class("new-admin-chip-red") {
                Background(
                    .variable(TokenKey.Colors.Palette.Red.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Red.border))
                Color(.variable(TokenKey.Colors.Palette.Red.text))
            },
            Class("new-admin-chip-blue") {
                Background(
                    .variable(TokenKey.Colors.Palette.Blue.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Blue.border))
                Color(.variable(TokenKey.Colors.Palette.Blue.text))
            },
            Class("new-admin-chip-green") {
                Background(
                    .variable(TokenKey.Colors.Palette.Green.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Green.border))
                Color(.variable(TokenKey.Colors.Palette.Green.text))
            },
            Class("new-admin-chip-yellow") {
                Background(
                    .variable(TokenKey.Colors.Palette.Yellow.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Yellow.border))
                Color(.variable(TokenKey.Colors.Palette.Yellow.text))
            },
            Class("new-admin-chip-orange") {
                Background(
                    .variable(TokenKey.Colors.Palette.Orange.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Orange.border))
                Color(.variable(TokenKey.Colors.Palette.Orange.text))
            },
            Class("new-admin-chip-purple") {
                Background(
                    .variable(TokenKey.Colors.Palette.Purple.background)
                )
                BorderColor(.variable(TokenKey.Colors.Palette.Purple.border))
                Color(.variable(TokenKey.Colors.Palette.Purple.text))
            },
        ]
    }

    public func html(context: inout RenderContext) -> Span {
        Span(label).class("new-admin-chip", "new-admin-chip-\(color.rawValue)")
    }
}
