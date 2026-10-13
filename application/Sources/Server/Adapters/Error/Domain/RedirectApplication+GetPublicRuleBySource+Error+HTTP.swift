public import RedirectApplication
import NIOHTTP1
import OpenAPIRuntime

extension GetPublicRuleBySource.Error: HTTPErrorRepresentable {
    var status: HTTPResponseStatus { .notFound }

    var content: ServerError.Details? {
        .init(
            code: .notFound,
            message: "Redirect rule not found.",
            reason: "redirect_rule_not_found"
        )
    }
}
