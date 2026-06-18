import RedirectDomain
import Application

public struct WriteRule: Scope {
    public let rule: any RuleRepository

    public init(rule: any RuleRepository) {
        self.rule = rule
    }
}
