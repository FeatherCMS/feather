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
                Variable(TokenKey.Colors.Background.tertiary, "#f5f6f8")
                Variable(TokenKey.Colors.Background.muted, "#fafbfc")

                Variable(TokenKey.Colors.Border.primary, "#d8dee7")
                Variable(TokenKey.Colors.Border.secondary, "#edf0f4")
                Variable(TokenKey.Colors.Border.tertiary, "#f5f6f8")
                Variable(TokenKey.Colors.Border.muted, "#fafbfc")

                Variable(TokenKey.Colors.BoxShadow.default, "rgba(17, 24, 39, 0.08)")

                Variable(TokenKey.Colors.Link.default, "#6d28d9")
                Variable(TokenKey.Colors.Link.hover, "#d946ef")
                Variable(TokenKey.Colors.Link.visited, "#7c3aed")
                Variable(TokenKey.Colors.Link.active, "#5b21b6")

                Variable(TokenKey.Colors.Accent.Primary.default, "#6536ab")
                Variable(TokenKey.Colors.Accent.Primary.hover, "#733fc2")

                Variable(TokenKey.Colors.Accent.Secondary.default, "#ef5eb0")
                Variable(TokenKey.Colors.Accent.Secondary.hover, "#7e22ce")

                Variable(TokenKey.Colors.Destructive.default, "#b4232d")
                Variable(TokenKey.Colors.Destructive.hover, "#8f1a22")

                Variable(TokenKey.Colors.Ghost.Primary.default, "#4b5563")
                Variable(TokenKey.Colors.Ghost.Primary.hover, "#374151")

                Variable(TokenKey.Colors.Ghost.Secondary.default, "#7c8490")
                Variable(TokenKey.Colors.Ghost.Secondary.hover, "#4b5563")

                Variable(TokenKey.Colors.Button.Disabled.background, "#e2e8f0")
                Variable(TokenKey.Colors.Button.Disabled.border, "#f8fafc")
                Variable(TokenKey.Colors.Button.Disabled.text, "#6b7280")

                Variable(TokenKey.Colors.Selection.primary, "#f6f7f9")
                Variable(TokenKey.Colors.Selection.secondary, "#e3e8ef")
                Variable(TokenKey.Colors.Selection.tertiary, "#e9edf2")
                Variable(TokenKey.Colors.Selection.muted, "#fafbfc")
                Variable(TokenKey.Colors.Selection.text, "#1f2937")
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Root {
                Variable(TokenKey.Colors.Text.primary, "#d6d1dc")
                Variable(TokenKey.Colors.Text.secondary, "#f5f0f7")
                Variable(TokenKey.Colors.Text.tertiary, "#a39aa8")
                Variable(TokenKey.Colors.Text.muted, "#716a75")

                Variable(TokenKey.Colors.Background.primary, "#000")
                Variable(TokenKey.Colors.Background.secondary, "#000")
                Variable(TokenKey.Colors.Background.tertiary, "#1f1f22")
                Variable(TokenKey.Colors.Background.muted, "#2a2a2e")

                Variable(TokenKey.Colors.Border.primary, "#29292d")
                Variable(TokenKey.Colors.Border.secondary, "#222226")
                Variable(TokenKey.Colors.Border.tertiary, "#1c1c20")
                Variable(TokenKey.Colors.Border.muted, "#121214")

                Variable(TokenKey.Colors.BoxShadow.default, "rgba(0, 0, 0, 0.45)")

                Variable(TokenKey.Colors.Link.default, "#c084fc")
                Variable(TokenKey.Colors.Link.hover, "#f0abfc")
                Variable(TokenKey.Colors.Link.visited, "#a855f7")
                Variable(TokenKey.Colors.Link.active, "#7c3aed")

                Variable(TokenKey.Colors.Accent.Primary.default, "#8c4ef0")
                Variable(TokenKey.Colors.Accent.Primary.hover, "#7a43d1")

                Variable(TokenKey.Colors.Accent.Secondary.default, "#ef5eb0")
                Variable(TokenKey.Colors.Accent.Secondary.hover, "#9333ea")

                Variable(TokenKey.Colors.Destructive.default, "#dc2626")
                Variable(TokenKey.Colors.Destructive.hover, "#b91c1c")

                Variable(TokenKey.Colors.Ghost.Primary.default, "#2c2c2e")
                Variable(TokenKey.Colors.Ghost.Primary.hover, "#1f1f22")

                Variable(TokenKey.Colors.Ghost.Secondary.default, "#525255")
                Variable(TokenKey.Colors.Ghost.Secondary.hover, "#3a3a3c")

                Variable(TokenKey.Colors.Button.Disabled.background, "#141416")
                Variable(TokenKey.Colors.Button.Disabled.border, "#242428")
                Variable(TokenKey.Colors.Button.Disabled.text, "#a39aa8")

                Variable(TokenKey.Colors.Selection.primary, "#202024")
                Variable(TokenKey.Colors.Selection.secondary, "#2a2a2e")
                Variable(TokenKey.Colors.Selection.tertiary, "#2c2c30")
                Variable(TokenKey.Colors.Selection.muted, "#111113")
                Variable(TokenKey.Colors.Selection.text, "#f5f0f7")
            }
        }

        Media(.prefersColorScheme(.dark) && .minWidth(600.px)) {
            Root {
                Variable(TokenKey.Colors.Background.primary, "#1c1c1e")
                Variable(TokenKey.Colors.Background.secondary, "#1c1c1e")
                Variable(TokenKey.Colors.Background.tertiary, "#303033")
                Variable(TokenKey.Colors.Background.muted, "#3a3a3e")
            }
        }
    }
}
