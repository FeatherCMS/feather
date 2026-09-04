import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminTestNewsletterIssueEmail {
    let controller: any AdminTestNewsletterIssueEmailController

    init() {
        controller = AdminTestNewsletterIssueEmailDefaultController()
    }

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
