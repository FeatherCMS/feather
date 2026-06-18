import SystemDomain
import Application

public struct ReadVariable: Scope {
    public let variable: any VariableQueries

    public init(variable: any VariableQueries) {
        self.variable = variable
    }
}
