import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

public struct AppContactFormSubmission {
    let controller: any AppContactFormSubmissionController

    public init() {
        self.controller = AppContactFormSubmissionDefaultController()
    }

    public func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
