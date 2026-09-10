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

                Variable(TokenKey.Colors.Materials.Tertiary.tint, "#eef0f3")
                Variable(TokenKey.Colors.Materials.Tertiary.text, "#374151")
                Variable(TokenKey.Colors.Materials.Tertiary.border, "#e5e7eb")
                Variable(TokenKey.Colors.Materials.Tertiary.hover, "#e6e8eb")

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

                Variable(TokenKey.Colors.Materials.Primary.tint, "#19191b")
                Variable(TokenKey.Colors.Materials.Primary.text, "#f7fbff")
                Variable(TokenKey.Colors.Materials.Primary.border, "#2b2b2e")
                Variable(TokenKey.Colors.Materials.Primary.hover, "#202023")

                Variable(TokenKey.Colors.Materials.Secondary.tint, "#202023")
                Variable(TokenKey.Colors.Materials.Secondary.text, "#e9edf2")
                Variable(TokenKey.Colors.Materials.Secondary.border, "#303036")
                Variable(TokenKey.Colors.Materials.Secondary.hover, "#28282b")

                Variable(TokenKey.Colors.Materials.Tertiary.tint, "#28282b")
                Variable(TokenKey.Colors.Materials.Tertiary.text, "#cbc8d0")
                Variable(TokenKey.Colors.Materials.Tertiary.border, "#38383e")
                Variable(TokenKey.Colors.Materials.Tertiary.hover, "#2f2f34")

                Variable(TokenKey.Colors.Accents.Primary.tint, "#7a43d1")
                Variable(TokenKey.Colors.Accents.Primary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Primary.border, "#733fc2")
                Variable(TokenKey.Colors.Accents.Primary.hover, "#8c4ef0")

                Variable(TokenKey.Colors.Accents.Secondary.tint, "#d6549b")
                Variable(TokenKey.Colors.Accents.Secondary.text, "#fff")
                Variable(TokenKey.Colors.Accents.Secondary.border, "#b6427f")
                Variable(TokenKey.Colors.Accents.Secondary.hover, "#ef5eb0")

                Variable(TokenKey.Colors.Buttons.Destructive.tint, "#b82d27")
                Variable(TokenKey.Colors.Buttons.Destructive.text, "#fff")
                Variable(TokenKey.Colors.Buttons.Destructive.border, "#7b1f25")
                Variable(TokenKey.Colors.Buttons.Destructive.hover, "#c93b49")

                Variable(TokenKey.Colors.Buttons.Ghost.Primary.tint, "#3a3a3e")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.text, "#f5f0f7")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.border, "#525255")
                Variable(TokenKey.Colors.Buttons.Ghost.Primary.hover, "#525255")

                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.tint, "#242428")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.text, "#d6d1dc")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.border, "#3b3b42")
                Variable(TokenKey.Colors.Buttons.Ghost.Secondary.hover, "#34343a")

                Variable(TokenKey.Colors.Buttons.Disabled.tint, "#1f1f22")
                Variable(TokenKey.Colors.Buttons.Disabled.text, "#716a75")
                Variable(TokenKey.Colors.Buttons.Disabled.border, "#242428")
                Variable(TokenKey.Colors.Buttons.Disabled.hover, "#2c2c2e")

                Variable(TokenKey.Colors.Selection.tint, "#202024")
                Variable(TokenKey.Colors.Selection.text, "#f5f0f7")

                Variable(TokenKey.Colors.BoxShadow.tint, "rgba(0, 0, 0, 0.45)")
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
