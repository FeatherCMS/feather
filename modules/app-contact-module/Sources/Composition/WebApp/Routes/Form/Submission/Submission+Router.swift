import ContactAppAPI
public import ContactModule
import FeatherValidation
public import FeatherWebShared
import Foundation
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebModuleWebApp

extension Submission {
    public struct Router {
        private let controller: any Controller.Interface

        public init(
            environment: AppEnvironment,
            turnstileVerifier: (any TurnstileVerifier)? = nil
        ) {
            self.controller = Controller.Default(
                environment: environment,
                turnstileVerifier: turnstileVerifier
            )
        }

        public func route(
            on router: Hummingbird.Router<DefaultRequestContext>
        ) {
            router.post(Routes.submission, use: controller.submit)
        }

        public struct Routes {
            private static let contact = RouterPath("api/v1/contact")

            static let submission =
                contact
                .appendingPath(RouterPath("{formKey}"))
                .appendingPath(RouterPath("submit"))

            public static func submissionAction(for formKey: String) -> String {
                let allowedCharacters = CharacterSet(
                    charactersIn:
                        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
                )
                let encodedKey =
                    formKey.addingPercentEncoding(
                        withAllowedCharacters: allowedCharacters
                    ) ?? ""
                return
                    contact
                    .appendingPath(RouterPath(encodedKey))
                    .appendingPath(RouterPath("submit"))
                    .description + "/"
            }
        }
    }
}
