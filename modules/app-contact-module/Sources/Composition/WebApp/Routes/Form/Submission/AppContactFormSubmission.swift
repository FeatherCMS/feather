import ContactWebShared
public import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
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
        apiBuilder: ContactAPIBuilder,
        turnstileVerifier: (any TurnstileVerifier)? = nil
    ) {
        self.controller = AppContactFormSubmissionDefaultController(
            apiBuilder: apiBuilder,
            turnstileVerifier: turnstileVerifier
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
