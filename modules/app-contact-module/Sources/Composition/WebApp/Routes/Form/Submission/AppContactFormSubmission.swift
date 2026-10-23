import FeatherValidation
public import FeatherWebShared
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
public import WebModuleWebApp

public struct AppContactFormSubmission {
    let controller: any AppContactFormSubmissionController

    public init(
        environment: AppEnvironment,
        turnstileVerifier: (any TurnstileVerifier)? = nil
    ) {
        self.controller = AppContactFormSubmissionDefaultController(
            environment: environment,
            turnstileVerifier: turnstileVerifier
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
