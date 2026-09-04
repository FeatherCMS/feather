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
import WebComponents
import WebBuilders

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

struct LoginForm: Leaf {

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

    func renderHTML() -> Form {
        Form {
            Section {
                EmailField(state: state.email).renderHTML()
            }
            .class("login-field")

            Section {
                PasswordField(state: state.password).renderHTML()
            }
            .class("login-field")

            Section {
                CheckboxField(state: state.isPersistent).renderHTML()
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
