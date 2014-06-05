extension SequenceOf {
    
    func Select<U>(f: (T) -> U) -> SequenceOf<U> {
        return SequenceOf<U>({() -> GeneratorOf<U> in
            var generator = self.generate()
            return GeneratorOf<U>({
                if let value = generator.next() {
                    return f(value);
                } else {
                    return nil
                }
                })
            })
    }
    
    func Where(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            return GeneratorOf<T>({
                while(true) {
                    if let value = generator.next() {
                        if f(value) {
                            return value
                        } else {
                            continue
                        }
                    } else {
                        return nil
                    }
                }
                })
            })
    }
    
    func Take(count: Int) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var i = 0
            return GeneratorOf<T>({
                if (count > i) {
                    i++
                    return generator.next()
                } else {
                    return nil
                }
                })
            })
    }
    
    func TakeWhile(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var conditionMet = true
            return GeneratorOf<T>({
                if conditionMet {
                    if let value = generator.next(){
                        if f(value) {
                            return value
                        } else {
                            conditionMet = false
                        }
                    } else {
                        return nil
                    }
                }
                return nil
                })
            })
    }
    
    func TakeUntil(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var conditionMet = false
            return GeneratorOf<T>({
                if !conditionMet {
                    if let value = generator.next(){
                        if f(value) {
                            conditionMet = true
                        } else {
                            return value
                        }
                    } else {
                        return nil
                    }
                }
                return nil
                })
            })
    }
    
    
    func Skip(count: Int) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var i = 0
            return GeneratorOf<T>({
                while (i < count) {
                    if let value = generator.next() {
                        i++
                    } else {
                        return nil
                    }
                }
                return generator.next()
                })
            })
    }
    
    func SkipWhile(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var conditionMet = true
            return GeneratorOf<T>({
                while (conditionMet) {
                    if let value = generator.next() {
                        if f(value) {
                            return value
                        } else {
                            conditionMet = false
                        }
                    } else {
                        return nil
                    }
                }
                return nil
                })
            })
    }
    
    
    func SkipUntil(f: (T) -> Bool) -> SequenceOf<T> {
        return SequenceOf<T>({() -> GeneratorOf<T> in
            var generator = self.generate()
            var conditionMet: Bool = false
            return GeneratorOf<T>({
                while (!conditionMet) {
                    if let value = generator.next() {
                        if f(value) {
                            conditionMet = true
                            return value
                        }
                    } else {
                        return nil
                    }
                }
                return generator.next()
                })
            })
    }
    
    func Any(f: (T) -> Bool) -> Bool {
        for value in self {
            if f(value) {
                return true
            }
        }
        return false
    }
    
    func Any() -> Bool {
        return self.Any({(x) -> Bool in true})
    }
    
    func All(f: (T) -> Bool) -> Bool {
        for value in self {
            if !f(value) {
                return false
            }
        }
        return true
    }
    
    func Contains<T: Equatable>(item: T) -> Bool {
        for value in self {
            if item == (value as T) {
                return true
            }
        }
        return false
    }
    
    func Count() -> Int {
        var i = 0
        for value in self {
            i++
        }
        return i
    }
    
    func First() -> T? {
        var generator = self.generate()
        return generator.next()
    }
    
    func ToArray() -> T[] {
        var output = T[]()
        for value in self {
            output += value
        }
        return output;
    }
}
