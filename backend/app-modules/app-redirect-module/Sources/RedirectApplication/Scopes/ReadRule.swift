import RedirectDomain
import Application

public struct ReadRule: Scope {
    public let rule: any RuleQueries

    public init(rule: any RuleQueries) {
        self.rule = rule
    }
}
