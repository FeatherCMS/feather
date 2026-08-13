import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebStandards

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

struct LoginForm: Component, FlowContent {

    struct State: FeatherAdmin.Object {
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
