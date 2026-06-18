//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

import CSS
import HTML
import SGML
import WebStandards

struct LoginForm: Component, FlowContent {

    struct State: Object {
        var email: EmailField.State
        var password: PasswordField.State
        var isPersistent: CheckboxField.State

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.key]
        }
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("error") {
            Color(.red)
        }
    }

    func content() -> some BasicTag {
        Form {
            Section {
                EmailField(state: state.email)
            }
            .class("login-field")

            Section {
                PasswordField(state: state.password)
            }
            .class("login-field")

            Section {
                CheckboxField(state: state.isPersistent)
            }
            .class("login-checkbox-field")

            Section {
                Input()
                    .type(.submit)
                    .name("button")
                    .value("Sign in")
                    .class("login-submit")
            }
        }
        .encType(.urlencoded)
        .method(.post)
        .action("/login/")
        .class("cms-form")
        .class("login-form")
    }
}
