#  Reddiation - A Reddit Client
>This project serves as an IOS Developer technical exam for [Eucaly](http://eucaly-inc.jp/)

>Selected Assumption A - Coach a junior engineer

> Developer Chrisler Laid [chrislaid.com](https://chrislaid.com/)

![App Image](https://firebasestorage.googleapis.com/v0/b/flashchat-3342f.appspot.com/o/86312829_2484497451816040_3162561862323666944_n.jpg?alt=media&token=14a4b737-079e-463f-89f4-67b09f19f72f)

## Features

* The app is for viewing subreddits and posts within a certain subreddit.
* User can select a subreddit from the list or search for a specific subreddit.
* When a subreddit is selected, all the posts in that subreddit will be shown on a list.
* Selecting a topic will display the contents of that post.

## Implementation
 
 1. Used the [Reddit API]( https://www.reddit.com/dev/api) and implemented MVC architectural pattern. No 3rd party library was installed. Everything was developed by using Xcode features and Swift programming language.
 2. A custom icon was created to represent the app, but still retained the reddit identity. 
 3. Base view controller was created for shared methods and properties between different view controllers.
 3. Created a view controller for the subreddits, with a table view, search bar controller, and embedded in a navigation controller. This view controller inherits from the base view controller. This controller transitions to the next controller which is the postings view controller via segueway. 
 4. The next view controller is for the postings, with a table view, and also inherits from the base view controller. This view controller transitions to the content view controller via segueway.
 5. The Last view controller has a webview that will load the content from a url.
 
 ## Used Codable Structs for parsing JSON
 ```
 struct SubredditsData: Codable {
     let data: SubredditData
 }

 struct SubredditData: Codable {
     let children: [Children]
 }

 struct Children: Codable {
     let data: ChildrenData
 }

 struct ChildrenData: Codable {
     let title: String
     let icon_img: String?
     let display_name_prefixed: String
     let name: String
 }
 
 struct PostingsData: Codable {
     let data: PostingData
 }

 struct PostingData: Codable {
     let children: [PostingChildren]
 }

 struct PostingChildren: Codable {
     let data: PostingChildrenData
 }

 struct PostingChildrenData: Codable {
     let title: String
     let thumbnail: String?
     let permalink: String
 }

 ```

