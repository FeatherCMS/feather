import HTML
import CSS
import SGML
import WebComponents
import WebBuilders

public struct NewAdminListShell<Table: FlowContent>: Leaf {

    public let table: Table

    public func rules(
    ) -> [any Rule] {
        Media {
            Custom(".table-shell") {
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(12.px)
                Overflow(.hidden)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
            Custom(".table-wrap") {
                Width(100.percent)
                OverflowX(.auto)
            }
            Custom(".cms-table") {
                Width(100.percent)
                BorderCollapse(.collapse)
                MinWidth(680.px)
            }
            Custom(".cms-table th, .cms-table td") {
                BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                TextAlign(.left)
                Padding(vertical: 12.px, horizontal: 14.px)
                FontSize(0.92.rem)
            }
            Custom(".cms-table th") {
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
                FontWeight(.number(600))
            }
            Custom(".cms-table tbody tr") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
            Custom(".cms-table tbody tr:hover") {
                Background(.variable(TokenKey.Colors.Materials.Tertiary.hover))
            }
            Custom(".cms-table tbody tr:last-child td") {
                BorderBottom(0)
            }
            Custom(".action-table th:first-child, .action-table td:first-child") {
                TextAlign(.left)
            }
            Custom(".action-table input[type='checkbox']") {
                Outline(0.px, .none)
                BoxShadow(.none)
                AccentColor(.variable(TokenKey.Colors.Accents.Primary.tint))
            }
            Custom(".select-cell") {
                Width(1.percent)
            }
            Custom(".action-cell") {
                WhiteSpace(.nowrap)
                TextAlign(.right)
            }
            Custom(".row-btn") {
                MarginRight(6.px)
                TextDecoration(.none)
            }
            Custom(".row-btn:last-child") {
                MarginRight(0)
            }
        }
            Media(.maxWidth(768.px)) {
                Custom(".cms-table, .cms-table thead, .cms-table tbody, .cms-table tr, .cms-table th, .cms-table td") {
                    Display(.block)
                    Width(100.percent)
                    MinWidth(0.px)
                }
                Custom(".cms-table thead") {
                    Position(.absolute)
                    Width(1.px)
                    Height(1.px)
                    Overflow(.hidden)
                    Opacity(0)
                }
                Custom(".cms-table tr") {
                    BorderBottom(1.px, .solid, .variable(TokenKey.Colors.Materials.Secondary.border))
                    Padding(vertical: 8.px, horizontal: 12.px)
                }
                Custom(".cms-table td") {
                    Border(0)
                    Padding(vertical: 8.px, horizontal: 0.px)
                }
                Custom(".cms-table td::before") {
                    Content(.string("attr(data-label)"))
                    Display(.block)
                    Color(.variable(TokenKey.Colors.Materials.Primary.text))
                    FontSize(0.78.rem)
                    FontWeight(.number(700))
                    TextTransform(.uppercase)
                    LetterSpacing(0.05.em)
                    MarginBottom(3.px)
                }
                Custom(".table-shell .table-wrap") {
                    OverflowX(.visible)
                }
            }

    }

    public init(
        table: Table
    ) {
        self.table = table
    }

    public func html(
    ) -> Div {
        Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        .class("table-shell")
    }
}
