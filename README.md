# PedidosYa interview test
PedidosYa code challenge for recruiting at iOS positions.
You can find the requirements of this exercise in the [pdf](https://github.com/mchirino89/RestoYa/blob/master/Enunciado.pdf) placed at the root of the repo.

# Technologies

Some frameworks were included in this project in order to speed up the process: 

* [Cocoapods 1.7.0](https://cocoapods.org/)
* [Alamofire](https://github.com/Alamofire/Alamofire)
* [ChiriUtils](https://github.com/mchirino89/ChiriUtils)
* [XCode 10.2.1](https://download.developer.apple.com/Developer_Tools/Xcode_10.2.1/Xcode_10.2.1.xip)

Instalation process is straight forward: first install _Cocoapods_ using the terminal by executing:
```
$ sudo gem install cocoapods
```

After the project has been cloned, proceed to open a terminal on the root folder and run 
```
$ pod update
$ pod install
```
And that's it. Everything should run smoothly.

# Reasoning

- MVVM and SOLID were at the heart of this development, always favoring composition over inherence (that's why you can see so many files for such a "small" project). It was _lego oriented_ design 😁
- Use of StackViews wherever possible to laverage its flexibility and layout power.
- Break down every delegate/data source across the project in order to avoid fat classes. `MainListViewController` is the _commander_ (sort of speak) of it all.

# Considerations 

There were tradeoffs in every major design decision behind the development. While it is true that SOLID principles are at the core of every choice made here, no peace of software is ever complete so there might be minor duplicated here and there for speeding sake. Some notes can be found across the project explaining the shortcomings of those implementations. Even though Unit test wasn't added on this project, all pods used here have great coverage (even the one of my own creation) so time was the key factor preventing me from polishing this even more.

# Things to improve
You might find odd for me to include this section since it looks like I'm sabotaging myself. The intention here is to acknowledge the things that, most likely due to lack of time, remain pending. Just to mention a few:
- Implement promises/GCD for serial API requests depending on each others.
- Add unit testing
- Abstract more behavior into protocols 
# Final notes

Even though none of the _plus_ assignments were tackled at first glace, you'll find some extra bits of love and thoughtful consideration elsewhere (especially if comments starting with **//-** are searched for in the workspace) like the dynamic map feature that reacts to user interaction. I thought I could show more of me by doing something of my own creation instead of simply adding a [**pod**](https://hackernoon.com/implement-infinite-scroll-or-pagination-in-ios-uitableview-using-swift-5-67ea1c4d236) to handle infinite scrolling

Hope I made myself clear in all of my intents. Looking forward to any feedback! 

Regards.
