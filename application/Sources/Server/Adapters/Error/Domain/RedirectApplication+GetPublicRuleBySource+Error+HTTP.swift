public import RedirectApplication
public import FeatherBackend
import NIOHTTP1

extension GetPublicRuleBySource.Error: HTTPErrorRepresentable {
    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: "Redirect rule not found.",
            reason: "redirect_rule_not_found"
        )
    }
}
