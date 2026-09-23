public import FeatherAdmin
import FeatherValidation
import HTML
public import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

public struct AppContactFormSubmission {
    let controller: any AppContactFormSubmissionController

    public init(apiBuilder: ContactAPIBuilder) {
        self.controller = AppContactFormSubmissionDefaultController(
            apiBuilder: apiBuilder
        )
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
