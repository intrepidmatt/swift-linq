var numbers = SequenceOf(1...10)
println(numbers.ToArray())
// [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

var squares = numbers.Select({(x) in x * x})
println(squares.ToArray())
// [1, 4, 9, 16, 25, 36, 49, 64, 81, 100]

var twoDigitSquares = squares.Where({(x) in x > 9 && x < 100})
println(twoDigitSquares.ToArray())
// [16, 25, 36, 49, 64, 81]

class Beer {
    let name: String
    let tastesGreat: Bool
    let lessFilling: Bool
    init(_ name: String, _ tastesGreat: Bool, _ lessFilling: Bool) {
        self.name = name
        self.tastesGreat = tastesGreat
        self.lessFilling = lessFilling
    }
}

var millerLight = Beer("Miller Light", true, true)
var budLight = Beer("Bud Light", false, true)
var budweiser = Beer("Budweiser", false, false)
var guiness = Beer("Guiness", true, false)
var blueMoon = Beer("Blue Moon", true, true)

var beers = [millerLight, budLight, budweiser, guiness, blueMoon]
var fillingBeers = SequenceOf(beers).Where({(beer) in !beer.lessFilling})

// Can use for-in to iterate any SequenceOf<T>
for beer in fillingBeers {
    println(beer.name)
}
// Budweiser
// Guiness

var lifeIsGood = SequenceOf(beers).Any({$0.tastesGreat && $0.lessFilling})
println(lifeIsGood)
// true

func isPrime(n: Int) -> Bool {
    if n == 2 {
        return true
    }
    
    if n % 2 == 0 {
        return false
    }
    
    var lim: Int = Int(floor(sqrt(Double(n))))
    
    for var i = 3; i <= lim; i+=2 {
        if n % i == 0 {
            return false
        }
    }
    
    return true
}

var hugeRange = 0...Int.max
var primes = SequenceOf(hugeRange).Where({(x) in isPrime(x)}) // Deferred execution
//var filteredPrimes = Array(hugeRange).filter({(x) in isPrime(x)}) // Crashes

var firstTenPrimes = primes.Take(10).ToArray()
println(firstTenPrimes)
// [1, 2, 3, 5, 7, 11, 13, 17, 19, 23]

var firstFourDigitPrime = primes.SkipUntil({(x) in x >= 1000}).First()
println(firstFourDigitPrime)
// 1009

var nums = [1, 3, 2, -8, 25, 25, 3]
println(nums.OrderBy({$0}).ToArray())

class Person {
    var firstName: String
    var lastName: String
    init(_ firstName: String, _ lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

var people = [Person("Matt", "Bridges"), Person("Jess", "Bridges"), Person("Jake", "Bridges"), Person("Andrea", "Garvey"), Person("Brian", "Garvey")]
var sortedPeople = people
    .OrderBy({$0.lastName})
    .ThenBy({$0.firstName})
    .Select({$0.lastName + ", " + $0.firstName})

for person in sortedPeople {
    println(person)
}