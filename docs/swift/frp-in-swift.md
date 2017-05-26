# Functional Reactive Programming in Swift

## What?

### Functional Programming
#### First-class function
Treats functions as first-class citizens

#### Higher-order function
A function that does at least one of the following:

- takes one or more functions as arguments 
- returns a function as its result

#### Pure function
Function which has no side-effects

#### Example 

```swift
// pure function
func addTen(_ a: Int) -> Int {
    return a + 10
}

// higher order function
func twice(_ f: @escaping (Int) -> (Int)) -> (Int) -> (Int) {
    return {
        f(f($0))
    }
}

// first-class citizen
let addTenTwice = twice(addTen)
addTenTwice(10) //30
let addTenFourTimes = twice(addTenTwice)
addTenFourTimes(10) //50


// a little more harder
func multiplyBySelf(_ a: Int) -> Int {
    return a * a
}

let g = twice(multiplyBySelf)
g(3) // 81
twice(g)(3) // 43046721

let a = 3 * 3 //9
let b = a * a //81
let c = b * b //6561
let d = c * c //43046721
```

### Reactive Programming 
#### Asynchronous Data Streams

```
--a---b-c---d---X---|->
```

- A stream is a sequence of ongoing events ordered in time
- Everything can be a stream
    - touch event
    - KVO
    - Notification
    - callback
    - Network response
    - timer
    - ...

### Functional + Reactive
#### Stream 
- Like an Array, it can hold anything
- Unlike an Array, you can't access it anytime you want, instread, you get notified when it's value get changed
- Like a pipe, if you missed the thing through it, it's gone forever

#### Transformation
- Change a stream to another stream, just like change a sequence to another
- Higher-order functions, map, filter, reduce, flatMap, etc

```swift
let reviewers = ["kimi", "qfu", "dhc", "x", "gaoji"]

// implement our own trnasformation functions
extension Array {
    func xy_map<T>(_ transform: (Element) -> T) -> [T] {
        var result: [T] = []

        for i in self {
            result.append(transform(i))
        }
        
        return result
    }
    
    func xy_filter(_ condition: (Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for i in self {
            if condition(i) {
                result.append(i)
            }
        }
        return result
    }
    
    func xy_reduce<T>(_ initialValue: T, _ combine: (T, Element) -> T) -> T {
        var value = initialValue
        
        for i in self {
            value = combine(value, i)
        }
        
        return value
    }
}

reviewers.xy_map {
    $0.uppercased()
}

reviewers.xy_filter {
    $0.characters.count > 3
}

// chain transformations
reviewers
    .xy_filter { $0.characters.count > 3 }
    .xy_reduce("") { return $0 + "\($1) review my code please~\n" }

// the original value hasn't been changed
reviewers

// a little bit about flatMap
let xxs = [[1, 2], [3, 4], [5, 6]]
let xso = [1, 2, 3, nil, 5]
// flatMap has 2 signature
xxs.flatMap { arr in
    arr.map {$0}
} // [1, 2, 3, 4, 5, 6]
xso.flatMap {
    $0
} // [1, 2, 3, 5]
```

#### Binding 
Binding makes program more reactive

### in Swift!

- Functional language
- Compiler & strong typed

Functional + Reactive + Swift, write awesome program!

## Why 
### Good
- Improve productivity
- Less and more centralised code
- Easy to maintain
- Avoid complexity with mutable state growing over time
- Change the way you think when coding

### Bad
- Learning curve is steep, but not that steep
- Hard to debug

The benefits it brings are worth we give it a try

## How
### Unserstand the basic reactive unit
#### Observable
It send messages
#### Subscriber
It consume messages


Observables are like `Sequence`,

```swift
// Observables are like Sequence
let xs = [1, 2, 3, 4, 5]

// iterate a sequence
for x in xs {
    print(x)
}

// the operation above equals
var xsIte = xs.makeIterator()
while let x = xsIte.next() {
    print(x)
}

// we can use Sequence feature to make a CountDown
struct CountDown: Sequence, IteratorProtocol {
    var num: Int
    
    var notify: (Int?) -> ()

    mutating func next() -> Int? {
        notify(num)
        if num == 0 {
            return nil
        }

        defer {
            num -= 1
        }
        return num
    }
}

var ite = CountDown(num: 10) {
        // as a subscriber, we are consuming messages
        print($0)
    }.makeIterator()

// now it's kind like a stream
// once next() called, it'll print the latest value, it's reactive now
ite.next() //10
ite.next() //9
ite.next() //8
```

How can we make our own Observable/Subscriber pattern?

```swift
import Foundation
import UIKit

class KeyValueObserver<A>: NSObject {
    let block: (A) -> ()
    let keyPath: String
    let object: NSObject
    init(object: NSObject, keyPath: String, _ block: @escaping (A) -> ()) {
        self.block = block
        self.keyPath = keyPath
        self.object = object
        super.init()
        object.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
    }
    
    deinit {
        print("deinit")
        object.removeObserver(self, forKeyPath: keyPath)
    }

    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        block(change![.newKey] as! A)
    }
}

class Observable<A> {
    private var callbacks: [(A) -> ()] = []
    var objects: [Any] = []
    
    static func pipe() -> ((A) -> (), Observable<A>) {
        let observable = Observable<A>()
        return ({ [weak observable] value in
            observable?.send(value)}, observable
        )
    }
    
    private func send(_ value: A) {
        for callback in callbacks {
            callback(value)
        }
    }
    
    func subscribe(callback: @escaping (A) -> ()) {
        callbacks.append(callback)
    }
}

extension UITextField {
    func observable() -> Observable<String> {
        let (sink, observable) = Observable<String>.pipe()
        let observer = KeyValueObserver(object: self, keyPath: #keyPath(text)) {
            sink($0)
        }
        observable.objects.append(observer)
        return observable
    }
}

var textField: UITextField? = UITextField()

textField?.text = "asd"
var observable = textField?.observable()
    
observable!.subscribe {
    print($0)
}

textField?.text = "asdjlas"
textField?.text = "asdjk"
textField = nil
observable = nil
```

### Integrate a reactive programming library
- ReactiveSwift
- ReactiveKit
- RxSwift

Neither can goes wrong, but I prefer RxSwift because,

- It's a [ReactiveX](http://reactivex.io/) official Swift implementation which means
    - Developer won't give it up (Maybe?)
    - You can easily switch to other platform
- It has a greate [community](https://github.com/RxSwiftCommunity)

## Credits
- [wiki/Higher-order function](https://en.wikipedia.org/wiki/Higher-order_function#Swift)
- [Functional Reactive Awesomeness with Swift](https://news.realm.io/news/altconf-ash-furrow-functional-reactive-swift/)
- [The introduction to Reactive Programming you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)
