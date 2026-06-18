//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 07..
//

import CSS
import WebStandards

extension CSS {

    struct Base: GlobalStyleComponent {

        static func rules() -> [any Rule] {
            Media {
                Custom("html") {
                    ScrollBehavior(.smooth)
                }
                Custom(
                    ".cms-table th:first-child,.cms-table td:first-child,.action-table th:first-child,.action-table td:first-child"
                ) {
                    TextAlign(.left).important()
                }
                Custom(
                    ".bulk-select-table th:first-child,.bulk-select-table td:first-child"
                ) {
                    TextAlign(.center).important()
                    Width(48.px)
                    MinWidth(48.px)
                }
                Custom(
                    ".bulk-select-table th:first-child input[type=\"checkbox\"],.bulk-select-table td:first-child input[type=\"checkbox\"]"
                ) {
                    Display(.block)
                    Margin(vertical: .length(0), horizontal: .auto)
                }
                Custom(".cms-table tbody tr:last-child td") {
                    BorderBottom(0)
                }
            }
        }
    }
}
