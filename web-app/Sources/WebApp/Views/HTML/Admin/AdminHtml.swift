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
import WebStandards

struct AdminHtml<T: Component>: Component {

    struct State {
        let head: AdminHeadElements.State
        let body: AdminBody<T>.State
    }

    let state: State

    func content() -> some BasicTag {
        Html {
            Head {
                AdminHeadElements(state: state.head)
            }
            Body {
                AdminBody<T>(state: state.body)
            }
        }
        .lang("en-US")
    }
}
