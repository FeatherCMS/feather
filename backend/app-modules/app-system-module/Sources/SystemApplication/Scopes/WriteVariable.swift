import SystemDomain
import Application

public struct WriteVariable: Scope {
    public let variable: any VariableRepository

    public init(variable: any VariableRepository) {
        self.variable = variable
    }
}
