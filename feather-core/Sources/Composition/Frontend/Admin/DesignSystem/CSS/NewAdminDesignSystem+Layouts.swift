import CSS
import WebBuilders

extension NewAdminDesignSystem {

    @Builder<CSS.Rule>
    func layouts(
    ) -> [any Rule] {
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
                Border(1.px, .solid, .variable(TokenKey.Colors.Materials.Primary.border))
                BorderRadius(20.px)
                BoxShadow(
                    0.px,
                    12.px,
                    blur: 26.px,
                    spread: 2.px,
                    color: CSSColor(stringLiteral: "var(--\(TokenKey.Colors.BoxShadow.tint.propertyName))")
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
    }
}
