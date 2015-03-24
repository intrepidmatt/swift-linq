//
//  OrderedSequenceOf.swift
//  swift-linq
//
//  Created by Matt Bridges on 3/24/15.
//  Copyright (c) 2015 Matt Bridges. All rights reserved.
//


class Comparer<T> {
    var comparer: (T, T) -> Bool
    init(comparer: (T, T) -> Bool) {
        self.comparer = comparer
    }
    class func defaultComparer<TElement: Comparable>() -> Comparer<TElement> {
        return Comparer<TElement>(comparer: { (x: TElement, y: TElement) -> Bool in
            x < y
        })
    }
    final func isOrderedBefore(x: T,_ y: T) -> Bool {
        return self.comparer(x, y)
    }
}

class ProjectionComparer<TElement, TKey: Comparable> : Comparer<TElement> {
    init(_ keySelector: (TElement) -> TKey, _ comparer: Comparer<TKey>) {
        super.init(comparer: { (x: TElement, y: TElement) -> Bool in
            var keyX = keySelector(x)
            var keyY = keySelector(y)
            return comparer.isOrderedBefore(keyX, keyY)
        })
    }
}

class ReverseComparer<T> : Comparer<T> {
    init(_ forwardComparer: Comparer<T>) {
        super.init(comparer: {(x: T, y: T) in
            return !forwardComparer.isOrderedBefore(x, y)
        })
    }
}

class CompoundComparer<T> : Comparer<T> {
    var primary: Comparer<T>
    var secondary: Comparer<T>
    
    init(_ primary: Comparer<T>, _ secondary: Comparer<T>) {
        self.primary = primary
        self.secondary = secondary
        super.init(comparer: { (x: T, y: T) -> Bool in
            var forwardResult = primary.isOrderedBefore(x, y)
            var backwardResult = primary.isOrderedBefore(y, x)
            
            // Primary comparer says they aren't equal
            if (forwardResult != backwardResult) {
                return forwardResult
            }
            return secondary.isOrderedBefore(x, y)
        })
    }
}

class OrderedSequenceOf<T> : SequenceType {
    var source: SequenceOf<T>
    var currentComparer: Comparer<T>
    
    init(_ source: SequenceOf<T>, _ comparer: Comparer<T>) {
        self.source = source
        self.currentComparer = comparer
    }
    
    func createOrderedSequenceOf<TKey: Comparable>(keySelector: (T) -> TKey, comparer: Comparer<TKey>) -> OrderedSequenceOf<T> {
        var secondaryComparer = ProjectionComparer(keySelector, comparer)
        return OrderedSequenceOf(self.source, CompoundComparer(self.currentComparer, secondaryComparer))
    }
    
    func generate() -> GeneratorOf<T> {
        var sortedSource = source.ToArray().sorted(self.currentComparer.isOrderedBefore)
        var sortedSequence = SequenceOf(sortedSource)
        return sortedSequence.generate()
    }
}

extension OrderedSequenceOf {
    func ThenBy<TKey: Comparable>(f: (T) -> TKey) -> OrderedSequenceOf<T> {
        return self.createOrderedSequenceOf(f, comparer: Comparer<TKey>.defaultComparer())
    }
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
    func Contains<T: Equatable>(item: T) -> Bool {
        return SequenceOf(self).Contains(item)
    }
    func ToArray() -> [T] {
        return SequenceOf(self).ToArray()
    }
}
