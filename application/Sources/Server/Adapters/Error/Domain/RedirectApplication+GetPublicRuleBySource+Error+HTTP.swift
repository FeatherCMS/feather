public import RedirectApplication
public import RedirectModule
public import FeatherBackend
public import NIOHTTP1

extension RedirectModule.Rule.Resolve.UseCase.Error: @retroactive HTTPErrorRepresentable {
    public var status: HTTPResponseStatus { .notFound }

    public var content: any HTTPErrorContent {
        DefaultHTTPErrorContent(
            message: "Redirect rule not found.",
            reason: "redirect_rule_not_found"
        )
    }
}
