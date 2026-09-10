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
                Variable(TokenKey.Colors.Link.default, "#8647b2")
                Variable(TokenKey.Colors.Link.hover, "#664ca6")
                Variable(TokenKey.Colors.Link.visited, "#8647b2")
                Variable(TokenKey.Colors.Link.active, "#3f2073")

                Variable(TokenKey.Colors.Materials.Primary.tint, "#fff")
                Variable(TokenKey.Colors.Materials.Primary.text, "#000")
                Variable(TokenKey.Colors.Materials.Primary.border, "#d8dee7")
                Variable(TokenKey.Colors.Materials.Primary.hover, "#f5f6f8")

                Variable(TokenKey.Colors.Materials.Secondary.tint, "#f8fafc")
                Variable(TokenKey.Colors.Materials.Secondary.text, "#111827")
                Variable(TokenKey.Colors.Materials.Secondary.border, "#edf0f4")
                Variable(TokenKey.Colors.Materials.Secondary.hover, "#edf0f4")

                Variable(TokenKey.Colors.Materials.Tertiary.tint, "#f5f6f8")
                Variable(TokenKey.Colors.Materials.Tertiary.text, "#4b5563")
                Variable(TokenKey.Colors.Materials.Tertiary.border, "#e5e7eb")
                Variable(TokenKey.Colors.Materials.Tertiary.hover, "#eef1f4")

                Variable(TokenKey.Colors.Accents.Primary.tint, "#6536ab")
                Variable(TokenKey.Colors.Accents.Primary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Primary.border, "#4b2780")
                Variable(TokenKey.Colors.Accents.Primary.hover, "#4b2780")

                Variable(TokenKey.Colors.Accents.Secondary.tint, "#bf3b87")
                Variable(TokenKey.Colors.Accents.Secondary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Secondary.border, "#8f285d")
                Variable(TokenKey.Colors.Accents.Secondary.hover, "#8f285d")

                Variable(TokenKey.Colors.Buttons.Destructive.tint, "#b4232d")
                Variable(TokenKey.Colors.Buttons.Destructive.text, "#fff")
                Variable(TokenKey.Colors.Buttons.Destructive.border, "#8f1620")
                Variable(TokenKey.Colors.Buttons.Destructive.hover, "#8f1a22")

                Variable(TokenKey.Colors.Buttons.Ghost.Primary.tint, "#374151")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.text, "#fff")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.border, "#1f2937")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.hover, "#0f172a")

                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.tint, "#e2e8f0")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.text, "#4b5563")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.border, "#cbd5e1")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.hover, "#cbd5e1")

                Variable(TokenKey.Colors.Buttons.Disabled.tint, "#eef0f2")
                Variable(TokenKey.Colors.Buttons.Disabled.text, "#9ca3af")
                Variable(TokenKey.Colors.Buttons.Disabled.border, "#e5e7eb")
                Variable(TokenKey.Colors.Buttons.Disabled.hover, "#e5e7eb")

                Variable(TokenKey.Colors.Selection.tint, "#fff")
                Variable(TokenKey.Colors.Selection.text, "#fff")

                Variable(TokenKey.Colors.BoxShadow.tint, "rgba(17, 24, 39, 0.08)")
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Root {

                Variable(TokenKey.Colors.Link.default, "#b06cff")
                Variable(TokenKey.Colors.Link.hover, "#c38cff")
                Variable(TokenKey.Colors.Link.visited, "#ef5eb0")
                Variable(TokenKey.Colors.Link.active, "#ff86aa")

                Variable(TokenKey.Colors.Materials.Primary.tint, "#1c1c1e")
                Variable(TokenKey.Colors.Materials.Primary.text, "#1f2937")
                Variable(TokenKey.Colors.Materials.Primary.border, "#d8dee7")
                Variable(TokenKey.Colors.Materials.Primary.hover, "#d8dee7")

                Variable(TokenKey.Colors.Materials.Secondary.tint, "#1c1c1e")
                Variable(TokenKey.Colors.Materials.Secondary.text, "#111827")
                Variable(TokenKey.Colors.Materials.Secondary.border, "#edf0f4")
                Variable(TokenKey.Colors.Materials.Secondary.hover, "#edf0f4")

                Variable(TokenKey.Colors.Materials.Tertiary.tint, "#f5f6f8")
                Variable(TokenKey.Colors.Materials.Tertiary.text, "#4b5563")
                Variable(TokenKey.Colors.Materials.Tertiary.border, "#f5f6f8")
                Variable(TokenKey.Colors.Materials.Tertiary.hover, "#f5f6f8")

                Variable(TokenKey.Colors.Accents.Primary.tint, "#6c64e8")
                Variable(TokenKey.Colors.Accents.Primary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Primary.border, "#574fd0")
                Variable(TokenKey.Colors.Accents.Primary.hover, "#9b94ff")

                Variable(TokenKey.Colors.Accents.Secondary.tint, "#d94a91")
                Variable(TokenKey.Colors.Accents.Secondary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Secondary.border, "#b83c79")
                Variable(TokenKey.Colors.Accents.Secondary.hover, "#ff86aa")

                Variable(TokenKey.Colors.Buttons.Destructive.tint, "#8f1a22")
                Variable(TokenKey.Colors.Buttons.Destructive.text, "#fff")
                Variable(TokenKey.Colors.Buttons.Destructive.border, "#70131a")
                Variable(TokenKey.Colors.Buttons.Destructive.hover, "#c93b49")

                Variable(TokenKey.Colors.Buttons.Ghost.Primary.tint, "#1f2937")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.text, "#fff")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.border, "#1f2937")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.hover, "#0f172a")

                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.tint, "#e2e8f0")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.text, "#4b5563")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.border, "#cbd5e1")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.hover, "#cbd5e1")

                Variable(TokenKey.Colors.Buttons.Disabled.tint, "#e5e7eb")
                Variable(TokenKey.Colors.Buttons.Disabled.text, "#6b7280")
                Variable(TokenKey.Colors.Buttons.Disabled.border, "#e5e7eb")
                Variable(TokenKey.Colors.Buttons.Disabled.hover, "#d1d5db")

                Variable(TokenKey.Colors.Selection.tint, "#fff")
                Variable(TokenKey.Colors.Selection.text, "#fff")

                Variable(TokenKey.Colors.BoxShadow.tint, "rgba(17, 24, 39, 0.08)")

//
//                Variable(TokenKey.Colors.Text.primary, "#d6d1dc")
//                Variable(TokenKey.Colors.Text.secondary, "#f5f0f7")
//                Variable(TokenKey.Colors.Text.tertiary, "#a39aa8")
//                Variable(TokenKey.Colors.Text.muted, "#716a75")
//
//                Variable(TokenKey.Colors.Background.primary, "#000")
//                Variable(TokenKey.Colors.Background.secondary, "#000")
//                Variable(TokenKey.Colors.Background.tertiary, "#1f1f22")
//                Variable(TokenKey.Colors.Background.muted, "#2a2a2e")
//
//                Variable(TokenKey.Colors.Border.primary, "#29292d")
//                Variable(TokenKey.Colors.Border.secondary, "#222226")
//                Variable(TokenKey.Colors.Border.tertiary, "#1c1c20")
//                Variable(TokenKey.Colors.Border.muted, "#121214")
//
//                Variable(TokenKey.Colors.BoxShadow.default, "rgba(0, 0, 0, 0.45)")
//
//                Variable(TokenKey.Colors.Link.default, "#8c4ef0")
//                Variable(TokenKey.Colors.Link.hover, "#f0abfc")
//                Variable(TokenKey.Colors.Link.visited, "#a855f7")
//                Variable(TokenKey.Colors.Link.active, "#7c3aed")
//
//                Variable(TokenKey.Colors.Accent.Primary.default, "#8c4ef0")
//                Variable(TokenKey.Colors.Accent.Primary.hover, "#7a43d1")
//
//                Variable(TokenKey.Colors.Accent.Secondary.default, "#ef5eb0")
//                Variable(TokenKey.Colors.Accent.Secondary.hover, "#9333ea")
//
//                Variable(TokenKey.Colors.Destructive.default, "#dc2626")
//                Variable(TokenKey.Colors.Destructive.hover, "#b91c1c")
//
//                Variable(TokenKey.Colors.Ghost.Primary.default, "#2c2c2e")
//                Variable(TokenKey.Colors.Ghost.Primary.hover, "#1f1f22")
//
//                Variable(TokenKey.Colors.Ghost.Secondary.default, "#525255")
//                Variable(TokenKey.Colors.Ghost.Secondary.hover, "#3a3a3c")
//
//                Variable(TokenKey.Colors.Button.Disabled.background, "#141416")
//                Variable(TokenKey.Colors.Button.Disabled.border, "#242428")
//                Variable(TokenKey.Colors.Button.Disabled.text, "#a39aa8")
//
//                Variable(TokenKey.Colors.Selection.primary, "#202024")
//                Variable(TokenKey.Colors.Selection.secondary, "#2a2a2e")
//                Variable(TokenKey.Colors.Selection.tertiary, "#2c2c30")
//                Variable(TokenKey.Colors.Selection.muted, "#111113")
//                Variable(TokenKey.Colors.Selection.text, "#f5f0f7")
            }
        }

//        Media(.prefersColorScheme(.dark) && .minWidth(600.px)) {
//            Root {
//                Variable(TokenKey.Colors.Background.primary, "#1c1c1e")
//                Variable(TokenKey.Colors.Background.secondary, "#1c1c1e")
//                Variable(TokenKey.Colors.Background.tertiary, "#303033")
//                Variable(TokenKey.Colors.Background.muted, "#3a3a3e")
//            }
//        }
    }
}
