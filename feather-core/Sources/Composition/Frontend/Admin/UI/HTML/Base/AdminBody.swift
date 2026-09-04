//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 08..
//

import CSS
import DOM
import HTML
import SGML
import SVG
import WebComponents
import WebBuilders

public struct AdminBody<T: Leaf>: Leaf {

    public struct State: Sendable {
        public let sidebar: AdminSidebar.State
        public let toast: AdminToastRedirect.Payload?
        public let content: T

        public init(
            sidebar: AdminSidebar.State,
            toast: AdminToastRedirect.Payload?,
            content: T
        ) {
            self.sidebar = sidebar
            self.toast = toast
            self.content = content
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func html() -> Div {
        Div {
            AdminTopBar().html()
            if let toast = state.toast {
                AdminToastBootstrap(payload: toast).html()
            }

            Div {
                AdminSidebar(state: state.sidebar).html()

                Main {
                    Div {
                        state.content.html()
                    }
                    .class("panel", "cms-content")
                }
            }
            .class("container")

            Script()
                .src(
                    "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/admin/toast.js"
                )
                .defer()
            Script()
                .src(
                    "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/admin/navigation.js"
                )
                .defer()
            Script()
                .src(
                    "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/admin/markdown-editor.js"
                )
                .defer()
            }
    }

}
