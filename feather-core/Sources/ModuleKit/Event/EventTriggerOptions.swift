//
//  EventTriggerOptions.swift
//  feather-core
//

public struct EventTriggerOptions: Sendable {

    private var values: [EventTriggerOptionID: any Sendable]

    public init() {
        values = [
            .contextPolicy: EventContextPolicy.strict,
            .invocationPolicy: EventInvocationPolicy.all,
        ]
    }

    public subscript<Value: Sendable>(
        key: EventTriggerOptionKey<Value>
    ) -> Value {
        get {
            guard let value = values[key.id] as? Value else {
                preconditionFailure("Missing event trigger option")
            }
            return value
        }
        set {
            values[key.id] = newValue
        }
    }
}
