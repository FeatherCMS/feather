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
import WebBuilders
import WebComponents

//
//  File.swift
//  web-app
//
//  Addd by Tibor Bödecs on 2026. 03. 01..
//

struct LoginForm: Component {

    struct State {
        var email: NewAdminFormFieldInput.State
        var password: NewAdminFormFieldInput.State
        var isPersistent: NewAdminFormFieldCheckbox.State
        var redirectPath: String

        mutating func apply(
            errors: [String: String]
        ) {
            email.error = errors[email.name]
        }
    }

    var state: State

    func selectors() -> [any Selector] {
        Class("error") {
            Color(.red)
        }
    }

    func html(context: inout RenderContext) -> Form {
        Form {
            Input()
                .type(.hidden)
                .name("redirect")
                .value(state.redirectPath)
            Section {
                context.render(NewAdminFormFieldInput(state: state.email))
            }
            .class("login-field")

            Section {
                context.render(NewAdminFormFieldInput(state: state.password))
            }
            .class("login-field")

            Section {
                context.render(
                    NewAdminFormFieldCheckbox(state: state.isPersistent)
                )
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
        .action(
            state.redirectPath == "/"
                ? "/login/"
                : "/login/?redirect=\(state.redirectPath.queryEncoded())"
        )
        .class("cms-form")
        .class("login-form")
    }
}
