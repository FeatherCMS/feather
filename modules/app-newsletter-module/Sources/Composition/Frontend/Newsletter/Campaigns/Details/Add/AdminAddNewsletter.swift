import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddNewsletter {
    let controller: any AdminAddNewsletterCampaignController

    func route(on router: Router<DefaultRequestContext>) {
        controller.route(on: router)
    }
}
