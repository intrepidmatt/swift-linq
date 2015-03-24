//
//  Array+Linq.swift
//  swiftlinq-test
//
//  Created by Matt Bridges on 3/23/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//

extension Array {
    func Select<U>(f: (T) -> U) -> SequenceOf<U> {
        return SequenceOf(self).Select(f)
    }
    func Where(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf(self).Where(f)
    }
    func Take(count: Int) -> SequenceOf<T> {
        return SequenceOf(self).Take(count)
    }
    func TakeWhile(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf(self).TakeWhile(f)
    }
    func TakeUntil(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf(self).TakeUntil(f)
    }
    func Skip(count: Int) -> SequenceOf<T> {
        return SequenceOf(self).Skip(count)
    }
    func SkipWhile(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf(self).SkipWhile(f)
    }
    func SkipUntil(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf(self).SkipUntil(f)
    }
    func Any(f: (T) -> Bool) -> Bool {
        return SequenceOf(self).Any(f)
    }
    func All(f: (T) -> Bool) -> Bool {
        return SequenceOf(self).All(f)
    }
}