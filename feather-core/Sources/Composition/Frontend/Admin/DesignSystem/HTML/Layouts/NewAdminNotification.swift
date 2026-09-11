//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import SGML
import WebComponents
import WebBuilders

public struct NewAdminNotification: Component {
    let payload: AdminToastRedirect.Payload

    public func html(context: inout RenderContext) -> some BasicTag {
        Div {
            // empty
        }
        .id("admin-toast")
        .hidden()
        .data("toast-type", payload.type)
        .data("toast-title", payload.title)
        .data("toast-message", payload.message)
        .data("toast-position", payload.position)
    }
}
