import CSS
import WebBuilders

extension AdminDesignSystem {

    @Builder<CSS.Rule>
    func layouts() -> [any Rule] {
        Media {
            Class("grid") {
                Display(.grid)
                ColumnGap(32.px)
                RowGap(32.px)
                GridColumn(.span(1))
                GridTemplateColumns(.repeat(1, .fraction(1.fr)))
            }
            Custom(".grid > *") {
                Overflow(.hidden)
            }
            Custom(".grid.grid-2") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
            Custom(".grid.grid-3") {
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
            }
            Custom(".grid.grid-4") {
                GridTemplateColumns(.repeat(4, .fraction(1.fr)))
            }
            Custom(".grid.grid-13-23, .grid.grid-23-13") {
                GridTemplateColumns(.fraction(1.fr))
            }

            Class("menu-container") {
                Display(.grid)
                GridTemplateColumns(.tracks([.fraction(1.fr)]))
                AlignItems(.flexStart)
                AlignContent(.flexStart)
                Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
                MinHeight(100.vh)
            }
            Custom(".menu-container main") {
                Margin(15.px)
                MarginBottom(32.px)
                Padding(15.px)
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Primary.border)
                )
                BorderRadius(20.px)
                BoxShadow(
                    0.px,
                    12.px,
                    blur: 26.px,
                    spread: 2.px,
                    color: CSSColor(
                        stringLiteral:
                            "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))"
                    )
                )
            }

        }
        Media(.screen && .minWidth(600.px)) {
            Custom(".grid.grid-221, .grid.grid-321, .grid.grid-421") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }

            Class("menu-container") {
                GridTemplateColumns(.tracks([.auto, .fraction(1.fr)]))
            }
        }
        Media(.screen && .minWidth(900.px)) {
            Custom(".grid.grid-211") {
                GridTemplateColumns(.repeat(2, .fraction(1.fr)))
            }
            Custom(".grid.grid-311, .grid.grid-321") {
                GridTemplateColumns(.repeat(3, .fraction(1.fr)))
            }
            Custom(".grid.grid-411, .grid.grid-421") {
                GridTemplateColumns(.repeat(4, .fraction(1.fr)))
            }
            Custom(".grid.grid-13-23") {
                UnsafeRawProperty(
                    name: "grid-template-columns",
                    value: "minmax(0, 1fr) minmax(0, 2fr)"
                )
            }
            Custom(".grid.grid-23-13") {
                UnsafeRawProperty(
                    name: "grid-template-columns",
                    value: "minmax(0, 2fr) minmax(0, 1fr)"
                )
            }
        }
        Media {
            Custom("dialog.admin-dialog") {
                Position(.fixed)
                UnsafeRawProperty(name: "inset", value: "0")
                Margin(.auto)
                Width(92.percent)
                MaxWidth(640.px)
                MaxHeight(90.vh)
                Padding(0.px)
                Border(0)
                BorderRadius(18.px)
                Overflow(.hidden)
                OverflowY(.auto)
                Background(color: .transparent)
                Color(.variable(TokenKey.Colors.Materials.Primary.text))
            }
            Custom("dialog.admin-dialog::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(128, 128, 128, 0.46)")
                    )
                )
                BackdropFilter(.blur(12.px))
            }
            Custom(".admin-dialog__panel") {
                Display(.flex)
                FlexDirection(.column)
                Gap(18.px)
                Padding(24.px)
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Secondary.border)
                )
                BorderRadius(18.px)
                Background(color: .color(CSSColor(stringLiteral: "#ffffff")))
                BoxShadow(
                    0.px,
                    18.px,
                    blur: 48.px,
                    spread: 0.px,
                    color: CSSColor(stringLiteral: "rgba(0, 0, 0, 0.24)")
                )
            }
            Custom(
                "html.admin-dialog-open, html.admin-dialog-open body"
            ) {
                Overflow(.hidden)
            }
            Custom(".admin-dialog__header") {
                Display(.flex)
                AlignItems(.center)
                JustifyContent(.spaceBetween)
                Gap(16.px)
            }
            Custom(".admin-dialog__header h2") {
                Margin(0.px)
                FontSize(1.35.rem)
                LineHeight(1.2)
            }
            Custom(".admin-dialog__close") { FlexShrink(0) }
            Custom(".admin-confirmation-items") {
                Margin(vertical: 20.px, horizontal: 0.px)
                Padding(vertical: 16.px, horizontal: 20.px)
                Background(.variable(TokenKey.Colors.Materials.Tertiary.tint))
                Border(
                    1.px,
                    .solid,
                    .variable(TokenKey.Colors.Materials.Tertiary.border)
                )
                BorderRadius(8.px)
            }
            Custom(".admin-confirmation-items p") { Margin(0) }
            Custom(".admin-confirmation-items ul") {
                Margin(vertical: 12.px, horizontal: 0.px)
                Padding(left: 20.px)
            }
            Custom(".admin-confirmation-items li") {
                Margin(vertical: 8.px, horizontal: 0.px)
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Custom("dialog.admin-dialog::backdrop") {
                Background(
                    color: .color(
                        CSSColor(stringLiteral: "rgba(0, 0, 0, 0.68)")
                    )
                )
            }
            Custom(".admin-dialog__panel") {
                Background(.variable(TokenKey.Colors.Materials.Primary.tint))
            }
        }
    }
}
