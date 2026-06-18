//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import WebStandards

extension CSS {

    struct Grid: GlobalStyleComponent {

        static func rules() -> [any Rule] {
            Media {
                Custom(".grid") {
                    Display(.grid)
                    ColumnGap(.length(32.px))
                    RowGap(.length(32.px))
                    GridColumn(.span(1))
                    GridTemplateColumns(
                        .repeat(1, .fraction(Fraction(value: 1)))
                    )
                }
                Custom(".grid > *") {
                    Overflow(.hidden)
                }
                Custom(".grid.grid-2") {
                    GridTemplateColumns(
                        .repeat(2, .fraction(Fraction(value: 1)))
                    )
                }
                Custom(".grid.grid-3") {
                    GridTemplateColumns(
                        .repeat(3, .fraction(Fraction(value: 1)))
                    )
                }
                Custom(".grid.grid-4") {
                    GridTemplateColumns(
                        .repeat(4, .fraction(Fraction(value: 1)))
                    )
                }
            }
            Media(.screen && .minWidth(600.px)) {
                Custom(".grid.grid-221,.grid.grid-321,.grid.grid-421") {
                    GridTemplateColumns(
                        .repeat(2, .fraction(Fraction(value: 1)))
                    )
                }
            }
            Media(.screen && .minWidth(900.px)) {
                Custom(".grid.grid-211") {
                    GridTemplateColumns(
                        .repeat(2, .fraction(Fraction(value: 1)))
                    )
                }
                Custom(".grid.grid-311,.grid.grid-321") {
                    GridTemplateColumns(
                        .repeat(3, .fraction(Fraction(value: 1)))
                    )
                }
                Custom(".grid.grid-411,.grid.grid-421") {
                    GridTemplateColumns(
                        .repeat(4, .fraction(Fraction(value: 1)))
                    )
                }
            }
        }
    }
}
