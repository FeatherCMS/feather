//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 08..
//

import CSS
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct AdminHtml<T: Leaf>: Leaf {

    struct State {
        let head: AdminHeadElements.State
        let body: AdminBody<T>.State
    }

    let state: State

    public func renderHTML() -> some BasicTag {
        Html {
            AdminHeadElements(state: state.head).renderHTML()
            Body {
                AdminBody<T>(state: state.body).renderHTML()
            }
        }
        .lang("en-US")
    }
}
