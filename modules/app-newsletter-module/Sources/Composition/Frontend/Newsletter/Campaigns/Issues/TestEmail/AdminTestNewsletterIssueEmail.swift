import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminTestNewsletterIssueEmail {
    let controller: any AdminTestNewsletterIssueEmailController

    init() {
        controller = AdminTestNewsletterIssueEmailDefaultController()
    }

    func route(on router: Router<AppRequestContext>) {
        controller.route(on: router)
    }
}
