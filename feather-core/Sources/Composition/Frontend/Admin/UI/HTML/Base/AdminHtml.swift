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

public struct AdminHtml<T: Component>: Component {

    struct State {
        let head: AdminHeadElements.State
        let body: AdminBody<T>.State
    }

    let state: State

    public func html(context: inout RenderContext) -> some BasicTag {
        Html {
            let renderedHead: Head = context.render(
                AdminHeadElements(state: state.head)
            )
            renderedHead
            Body {
                context.render(AdminBody<T>(state: state.body))
            }
        }
        .lang("en-US")
    }
}
