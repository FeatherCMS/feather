import FeatherModuleKit
import Foundation

public enum AnalyticsLogRequestMetadata {

    private static let aiUserAgentPattern =
        #"(addsearchbot|agentdatabot|agenttimes|ai.?2.?bot|aihitbot|aiwebindex|amazonbot|amazon.?qbusiness|amazonbuyforme|amzn.?searchbot|amzn.?user|andibot|anomura|anthropic.?ai|apifybot|apifywebsitecontentcrawler|applebot(-extended)?|azureai.?searchbot|bedrockbot|bigsur\.ai|bixelbot|brightbot|buddybot|bytespider|ccbot|channel3bot|chatglm.?spider|chatgpt|claude|cloudflare.?autorag|cloudflarebrowserrenderingcrawler|cloudvertexbot|cohere.?ai|cohere-training-data-crawler|copilot|cotoyogi|cragcrawler|crawl4ai|crawlspace|cursor|deepseekbot|devin|diffbot(-user)?|doubao.?bot|duckassistbot|echobot|echoboxbot|erniebot|exa(search)?bot|facebookbot|facebookexternalhit|firecrawl(agent)?|geisthaus-pagefetcher|gemini|google-agent|google-cloudvertexbot|google-extended|google-firebase|google-gemini-cli|google-notebooklm|google-read-aloud|googleagent|googleother|gptbot|grok(appandroid|bot|deepsearch)?|xai-(bot|grok|searchbot|web-crawler)|henkbot|hunyuan|iask(bot|spider)|imagesiftbot|img2dataset|kagi-fetcher|kangaroo.?bot|kimi(-agent|-searchbot|-user)?|kimibot|klaviyoaibot|laion(huggingface-processor|downloader)|linerbot|linkupbot|manus-user|meta-external(agent|fetcher|ads)|meta-webindexer|mistralai-(index|training|user)|moonshotbot|mycentrala[s]?scraperbot|newsai|notebooklm|novaact|oai-(ads|search)bot|openai|opencode|operator|pangu.?bot|panscient(\.com)?|perplexity(-user)?bot?|phindbot|poggio-citations|poseidon research crawler|qodercli|qwen(-user)?bot?|reflectionbot|shap(-user)?bot|tavilybot|tongyibot|twinagent|useai|wrtnbot|yiyanbot|youbot|zanistabot|aliyunbot)"#
    private static let botUserAgentPattern =
        #"(bot|crawler|spider|slurp|preview|scrapy|facebookexternalhit|googlebot|bingbot|msnbot|baiduspider|yandex)"#

    public static func classifyUserAgent(
        _ value: String?
    ) -> Log.TrafficCategory {
        guard let value, !value.isEmpty else { return .human }
        let userAgent = value.lowercased()
        if userAgent.range(
            of: aiUserAgentPattern,
            options: .regularExpression
        ) != nil {
            return .ai
        }
        if userAgent.range(
            of: botUserAgentPattern,
            options: .regularExpression
        ) != nil {
            return .bot
        }
        return .human
    }

    public static func parseAcceptLanguage(
        _ value: String?
    ) -> (language: String?, region: String?) {
        guard let value, let first = value.split(separator: ",").first else {
            return (nil, nil)
        }
        let code =
            first
            .split(separator: ";", maxSplits: 1)
            .first?
            .whitespaceTrimmed
        guard let code, !code.isEmpty else {
            return (nil, nil)
        }
        let parts = code.split(separator: "-", maxSplits: 1).map(String.init)
        let language = parts.first?.lowercased()
        let region = parts.count > 1 ? parts[1].uppercased() : nil
        return (language, region)
    }

    public static func parseUserAgent(
        _ value: String?
    ) -> (
        osName: String?, osVersion: String?, browserName: String?,
        browserVersion: String?, engineName: String?, engineVersion: String?,
        deviceVendor: String?, deviceType: String?, deviceModel: String?,
        cpu: String?
    ) {
        guard let value, !value.isEmpty else {
            return (nil, nil, nil, nil, nil, nil, nil, nil, nil, nil)
        }

        let lowercased = value.lowercased()

        let browserName: String?
        if lowercased.contains("firefox/") {
            browserName = "Firefox"
        }
        else if lowercased.contains("edg/") {
            browserName = "Edge"
        }
        else if lowercased.contains("chrome/") {
            browserName = "Chrome"
        }
        else if lowercased.contains("safari/") {
            browserName = "Safari"
        }
        else {
            browserName = nil
        }

        let osName: String?
        if lowercased.contains("iphone") || lowercased.contains("ipad") {
            osName = "iOS"
        }
        else if lowercased.contains("mac os x") {
            osName = "macOS"
        }
        else if lowercased.contains("android") {
            osName = "Android"
        }
        else if lowercased.contains("windows") {
            osName = "Windows"
        }
        else if lowercased.contains("linux") {
            osName = "Linux"
        }
        else {
            osName = nil
        }

        let deviceType: String?
        if lowercased.contains("mobile") || lowercased.contains("iphone") {
            deviceType = "mobile"
        }
        else if lowercased.contains("ipad") || lowercased.contains("tablet") {
            deviceType = "tablet"
        }
        else {
            deviceType = "desktop"
        }

        return (
            osName,
            nil,
            browserName,
            nil,
            nil,
            nil,
            nil,
            deviceType,
            nil,
            nil
        )
    }
}
