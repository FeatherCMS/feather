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

struct AdminBody<T: Component>: Component, FlowContent {

    struct State {
        let sidebar: AdminSidebar.State
        let toast: AdminToastRedirect.Payload?
        let content: T
    }

    let state: State

    func content() -> some BasicTag {
        AdminTopBar()
        if let toast = state.toast {
            AdminToastBootstrap(payload: toast)
        }

        Div {
            AdminSidebar(state: state.sidebar)

            Main {
                Div {
                    state.content
                }
                .class("panel", "cms-content")
            }
        }
        .class("container")

        Script()
            .src(
                "\(AppEnvironmentStore.current.publicOrigins.staticBaseURL)/toast.js"
            )
            .setAttribute(name: "defer", value: "")
        Script()
            .src("/admin-navigation.js")
            .setAttribute(name: "defer", value: "")
    }
}
