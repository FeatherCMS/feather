public import CSS
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminListShell<Table: FlowContent>: Component {

    public let table: Table
    public let layout: NewAdminListTableLayout?
    public let hasSelection: Bool

    public func rules() -> [any Rule] {
        var rules: [any Rule] = [
            Media {
                Custom(".table-shell") {
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Primary.border)
                    )
                    BorderRadius(12.px)
                    Overflow(.hidden)
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
                Custom(".table-wrap") {
                    Width(100.percent)
                    OverflowX(.auto)
                }
                Custom(".cms-table") {
                    Width(100.percent)
                    TableLayout(.fixed)
                    BorderCollapse(.collapse)
                    MinWidth(680.px)
                }
                Custom(".cms-table th, .cms-table td") {
                    BorderBottom(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Primary.border)
                    )
                    TextAlign(.left)
                    Padding(vertical: 12.px, horizontal: 14.px)
                    FontSize(0.92.rem)
                }
                Custom(".cms-table th") {
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                    Color(.variable(TokenKey.Colors.Materials.Primary.text))
                    FontWeight(.number(600))
                }
                Custom(".cms-table tbody tr") {
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
                Custom(".cms-table tbody tr:hover") {
                    Background(
                        .variable(TokenKey.Colors.Materials.Tertiary.hover)
                    )
                }
                Custom(".cms-table tbody tr:last-child td") {
                    BorderBottom(0)
                }
                Custom(
                    ".action-table th:first-child, .action-table td:first-child"
                ) {
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
            },
            Media(.maxWidth(768.px)) {
                Custom(
                    ".cms-table, .cms-table thead, .cms-table tbody, .cms-table tr, .cms-table th, .cms-table td"
                ) {
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
                    BorderBottom(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Secondary.border)
                    )
                    Padding(vertical: 12.px, horizontal: 14.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
                Custom(".cms-table tbody") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(0.px)
                }
                Custom(".cms-table td") {
                    Border(0)
                    Padding(vertical: 8.px, horizontal: 0.px)
                }
                Custom(".cms-table td:not(.action-cell)") {
                    OverflowWrap(.anywhere)
                }
                Custom(".cms-table td.select-cell") {
                    Display(.flex)
                    AlignItems(.center)
                    Width(100.percent)
                    Padding(vertical: 4.px, horizontal: 0.px)
                }
                Custom(".cms-table td.select-cell::before") {
                    Display(.none)
                }
                Custom(".cms-table td::before") {
                    Content(.string("attr(data-label)"))
                    Display(.block)
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    FontSize(0.78.rem)
                    FontWeight(.number(700))
                    TextTransform(.uppercase)
                    LetterSpacing(0.05.em)
                    MarginBottom(3.px)
                }
                Custom(".table-shell .table-wrap") {
                    OverflowX(.visible)
                }
            },
        ]

        if let layout {
            rules.append(
                Media(.minWidth(769.px)) {
                    Custom(".table-shell.\(layout.className) .cms-table") {
                        Display(.block)
                        MinWidth(layout.minimumWidth.px)
                    }
                    Custom(
                        ".table-shell.\(layout.className) .cms-table thead, .table-shell.\(layout.className) .cms-table tbody"
                    ) {
                        Display(.contents)
                    }
                    Custom(".table-shell.\(layout.className) .cms-table tr") {
                        Display(.grid)
                        AlignItems(.stretch)
                        UnsafeRawProperty(
                            name: "grid-template-columns",
                            value: layout.gridTemplateColumns(
                                hasSelection: hasSelection
                            )
                        )
                    }
                    Custom(
                        ".table-shell.\(layout.className) .cms-table th, .table-shell.\(layout.className) .cms-table td"
                    ) {
                        Display(.flex)
                        AlignItems(.center)
                        Width(100.percent)
                        MinWidth(0.px)
                        BoxSizing(.borderBox)
                    }
                    Custom(
                        ".table-shell.\(layout.className) .cms-table th:not(.action-cell), .table-shell.\(layout.className) .cms-table td:not(.action-cell)"
                    ) {
                        OverflowWrap(.anywhere)
                    }
                }
            )
        }

        return rules

    }

    public init(
        layout: NewAdminListTableLayout? = nil,
        hasSelection: Bool = false,
        table: Table
    ) {
        self.table = table
        self.layout = layout
        self.hasSelection = hasSelection
    }

    public func html(context: inout BuilderContext) -> Div {
        let content = Div {
            Div {
                table
            }
            .class("table-wrap")
        }
        var shell = content.class("table-shell")
        if let layout {
            shell = shell.class(layout.className)
        }
        return shell
    }
}
