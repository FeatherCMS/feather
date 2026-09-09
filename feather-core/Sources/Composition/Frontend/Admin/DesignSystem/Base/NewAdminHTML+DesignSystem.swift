//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import CSS
import SGML
import WebComponents
import WebBuilders


struct HTMLDesignSystem: Component {

    func scripts() -> [String] {
        #"console.log('👋 Welcome to Feather CMS!')"#
    }

    func rules() -> [any Rule] {
        Media {
            Root {
                Variable(TokenKey.Colors.Text.primary, "#1f2937")
                Variable(TokenKey.Colors.Text.secondary, "#111827")
                Variable(TokenKey.Colors.Text.tertiary, "#4b5563")
                Variable(TokenKey.Colors.Text.muted, "#6b7280")

                Variable(TokenKey.Colors.Background.primary, "#ffffff")
                Variable(TokenKey.Colors.Background.secondary, "#f8fafc")
                Variable(TokenKey.Colors.Background.tertiary, "#f1f5f9")
                Variable(TokenKey.Colors.Background.muted, "#e2e8f0")

                Variable(TokenKey.Colors.Border.primary, "#cbd5e1")
                Variable(TokenKey.Colors.Border.secondary, "#e2e8f0")
                Variable(TokenKey.Colors.Border.tertiary, "#f1f5f9")
                Variable(TokenKey.Colors.Border.muted, "#f8fafc")

                Variable(TokenKey.Colors.BoxShadow.default, "rgba(17, 24, 39, 0.08)")

                Variable(TokenKey.Colors.Link.default, "#6d28d9")
                Variable(TokenKey.Colors.Link.secondary, "#9333ea")
                Variable(TokenKey.Colors.Link.hover, "#d946ef")
                Variable(TokenKey.Colors.Link.visited, "#7c3aed")
                Variable(TokenKey.Colors.Link.active, "#5b21b6")

                Variable(TokenKey.Colors.Accent.primary, "#6d28d9")
                Variable(TokenKey.Colors.Accent.secondary, "#9333ea")
                Variable(TokenKey.Colors.Accent.tertiary, "#d946ef")
                Variable(TokenKey.Colors.Accent.muted, "#ddd6fe")

                Variable(TokenKey.Colors.Selection.default, "#f1f5f9")
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Root {
                Variable(TokenKey.Colors.Text.primary, "#d6d1dc")
                Variable(TokenKey.Colors.Text.secondary, "#f5f0f7")
                Variable(TokenKey.Colors.Text.tertiary, "#a39aa8")
                Variable(TokenKey.Colors.Text.muted, "#716a75")

                Variable(TokenKey.Colors.Background.primary, "#000")
                Variable(TokenKey.Colors.Background.secondary, "#141416")
                Variable(TokenKey.Colors.Background.tertiary, "#1f1f22")
                Variable(TokenKey.Colors.Background.muted, "#2a2a2e")

                Variable(TokenKey.Colors.Border.primary, "#2c2c30")
                Variable(TokenKey.Colors.Border.secondary, "#242428")
                Variable(TokenKey.Colors.Border.tertiary, "#1d1d21")
                Variable(TokenKey.Colors.Border.muted, "#141416")

                Variable(TokenKey.Colors.BoxShadow.default, "rgba(0, 0, 0, 0.72)")

                Variable(TokenKey.Colors.Link.default, "#c084fc")
                Variable(TokenKey.Colors.Link.secondary, "#e879f9")
                Variable(TokenKey.Colors.Link.hover, "#f0abfc")
                Variable(TokenKey.Colors.Link.visited, "#a855f7")
                Variable(TokenKey.Colors.Link.active, "#7c3aed")

                Variable(TokenKey.Colors.Accent.primary, "#a855f7")
                Variable(TokenKey.Colors.Accent.secondary, "#c026d3")
                Variable(TokenKey.Colors.Accent.tertiary, "#e879f9")
                Variable(TokenKey.Colors.Accent.muted, "#7c3aed")

                Variable(TokenKey.Colors.Selection.default, "#1c1c1e")
            }
        }

        Media { 
            Custom("a:link") {
                Color(.variable(TokenKey.Colors.Link.default))
            }
            Custom("a:visited") {
                Color(.variable(TokenKey.Colors.Link.visited))
            }
            Custom("a:hover") {
                Color(.variable(TokenKey.Colors.Link.hover))
            }
            Custom("a:active") {
                Color(.variable(TokenKey.Colors.Link.active))
            }
            Class("panel") {
                Background(.variable(TokenKey.Colors.Background.secondary))
            }
        }
    }
}
