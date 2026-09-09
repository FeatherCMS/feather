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
                Variable(TokenKey.Colors.Text.primary, "#333")
                Variable(TokenKey.Colors.Text.secondary, "#000")
                Variable(TokenKey.Colors.Text.tertiary, "#666")
                Variable(TokenKey.Colors.Text.muted, "#999")

                Variable(TokenKey.Colors.Background.primary, "#fff")
                Variable(TokenKey.Colors.Background.secondary, "#f2f2f7")
                Variable(TokenKey.Colors.Background.tertiary, "#efefef")
                Variable(TokenKey.Colors.Background.muted, "#e0e0e0")
                //--background-color-4: #afafaf;

                Variable(TokenKey.Colors.Border.primary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.secondary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.tertiary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.muted, "#3a3a3c")

                Variable(TokenKey.Colors.Link.default, "#c53c6f")
                Variable(TokenKey.Colors.Link.hover, "#bf3b87")
                Variable(TokenKey.Colors.Link.visited, "#8647b2")
                Variable(TokenKey.Colors.Link.active, "#664ca6")

                Variable(TokenKey.Colors.Selection.default, "#e0e0e0")
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Root {
                Variable(TokenKey.Colors.Text.primary, "#c9c9c9")
                Variable(TokenKey.Colors.Text.secondary, "#f0f0f0")
                Variable(TokenKey.Colors.Text.tertiary, "#999")
                Variable(TokenKey.Colors.Text.muted, "#ccc")

                Variable(TokenKey.Colors.Background.primary, "#000")
                Variable(TokenKey.Colors.Background.secondary, "#1c1c1e")
                Variable(TokenKey.Colors.Background.tertiary, "#262626")
                Variable(TokenKey.Colors.Background.muted, "#333")
                
                //121212
//                --background-color-4: #606060;

                Variable(TokenKey.Colors.Border.primary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.secondary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.tertiary, "#3a3a3c")
                Variable(TokenKey.Colors.Border.muted, "#3a3a3c")

                Variable(TokenKey.Colors.Link.default, "#ff6482")
                Variable(TokenKey.Colors.Link.hover, "#ef5eb0")
                Variable(TokenKey.Colors.Link.visited, "#b06cff")
                Variable(TokenKey.Colors.Link.active, "#7e78ff")

                Variable(TokenKey.Colors.Selection.default, "#333333")
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
