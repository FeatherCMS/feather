//
//  EventTriggerOptionKey.swift
//  feather-core
//

enum EventTriggerOptionID: Hashable, Sendable {
    case contextPolicy
    case invocationPolicy
}

public struct EventTriggerOptionKey<Value: Sendable>: Sendable {

    let id: EventTriggerOptionID

    private init(id: EventTriggerOptionID) {
        self.id = id
    }
}

extension EventTriggerOptionKey where Value == EventContextPolicy {

    public static var contextPolicy: Self {
        Self(id: .contextPolicy)
    }
}

extension EventTriggerOptionKey where Value == EventInvocationPolicy {

    public static var invocationPolicy: Self {
        Self(id: .invocationPolicy)
    }
}
