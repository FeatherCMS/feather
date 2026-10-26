import ContactAppAPI
public import ContactModule
import FeatherValidation
public import FeatherWebShared
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebModuleWebApp

extension Submission {
    public struct Router {
        public struct Routes: Sendable {
            public let submission: WebRoute

            public init(root: WebRoute) {
                submission = root
                    .appending(pathComponent: "api")
                    .appending(pathComponent: "v1")
                    .appending(pathComponent: "contact")
                    .appending(parameter: "formKey")
                    .appending(pathComponent: "submit")
            }

            public static let standard = Routes(root: .root)

            public func submissionActionPath(for formKey: String) -> String {
                submission.path(parameter: "formKey", value: formKey)
            }
        }

        private let controller: any Controller.Interface
        private let routes: Routes

        public init(
            environment: AppEnvironment,
            turnstileVerifier: (any TurnstileVerifier)? = nil,
            routes: Routes = .standard
        ) {
            self.routes = routes
            self.controller = Controller.Default(
                environment: environment,
                turnstileVerifier: turnstileVerifier
            )
        }

        public func route(
            on router: Hummingbird.Router<DefaultRequestContext>
        ) {
            router.post(routes.submission.routerPath, use: controller.submit)
        }
    }
}
