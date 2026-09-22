//
//  File.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 09. 04..
//

import HTML
import SGML
import SVG
import WebBuilders
import WebComponents

public struct NewAdminTopBar: Component {

    public struct State: Sendable, Equatable {

        public let profileImageURL: String?

        public init(profileImageURL: String? = nil) {
            self.profileImageURL = profileImageURL
        }
    }

    private let notification: NewAdminNotification?
    private let state: State

    public init(
        notification: NewAdminNotification? = nil,
        state: State = .init()
    ) {
        self.notification = notification
        self.state = state
    }

    private func renderMenuTrigger(context: inout BuilderContext) -> Div {

        Div {
            Label {
                FeatherIcons.sidebar()
                    .class("menu-trigger-icon menu-trigger-desktop")
                FeatherIcons.menu()
                    .class("menu-trigger-icon menu-trigger-mobile")
                Span("Menu").class("sr-only")
            }
            .for("menuToggle")
            .ariaLabel("Toggle menu")
            .class("menu-trigger")
        }
        .class("top-bar-brand")
    }

    private func renderTitle(context: inout BuilderContext) -> Div {
        Div {
            Div {
                H1 {
                    A("Feather CMS")
                        .href("/")
                        .class("top-bar-title-link")
                }
            }
            .class("top-bar-title-copy")
            if let notification {
                context.build(notification)
            }
        }
        .class("top-bar-title")
    }

    private func renderAccountActions(context: inout BuilderContext) -> Div {

        Div {
            Input()
                .type(.checkbox)
                .id("accountToggle")
                .name("accountToggle")
            Label {
                if let profileImageURL = state.profileImageURL {
                    Img(src: profileImageURL, alt: "")
                }
                else {
                    FeatherIcons.user().class("account-profile-icon")
                }
                Span("My profile")
                    .class("sr-only")
            }
            .for("accountToggle")
            .class("account-trigger")
            .ariaLabel("Toggle account menu")

            Ul {
                Li { A("Profile").href("/admin/account/profile/") }
                Li { A("Settings").href("/admin/account/settings/") }
                Li { A("Logout").href("/logout") }
            }
            .class("account-menu")
        }
        .class("top-bar-actions")
    }

    public func html(context: inout BuilderContext) -> some BasicTag {
        Div {
            renderMenuTrigger(context: &context)
            renderTitle(context: &context)
            renderAccountActions(context: &context)
        }
        .class("top-bar")
    }
}
