import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletterIssue {
    let controller: any AdminAddNewsletterIssueController

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
