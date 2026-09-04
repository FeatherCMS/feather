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
                Variable(TokenKey.Color.primary.rawValue, "#000")
            }
            Custom("body") {
                Background(color: "#fff")
                UnsafeRawProperty(name: "color", value: TokenKey.Color.primary.rawValue.variable)
            }
        }
        Media(.prefersColorScheme(.dark)) {
            Root {
                Variable(TokenKey.Color.primary.rawValue, "#fff")
            }
            Custom("body") {
                Background(color: "#000")
                UnsafeRawProperty(name: "color", value: TokenKey.Color.primary.rawValue.variable)
            }
        }
    }
}
