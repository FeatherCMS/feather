import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterIssue {
    let controller: any AdminAddNewsletterIssueController

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
