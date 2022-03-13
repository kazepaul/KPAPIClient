# KPAPIClient

***Important*** This project is just a self practice about APIClient + Combine + SwiftUI + MVVM.

## What I want to do in the project?
1. Build a app by using SwiftUI
2. Handling different API call with APIClient+Almofire
3. Handle the API resquest and response with Combine framework
4. Use MVVM Architecture

## Concept
<img width="841" alt="Screen Shot 2022-03-13 at 21 16 16" src="https://user-images.githubusercontent.com/45927475/158058986-34c7f6c1-b745-4189-bf2c-9fc3a34265ba.png">

## Good points:+1::+1:
**Network Layer:**

👍 One API Request one file, easy to handle and maintain.

👍 Every API Request have its associated type for Response (for example: KanaKanjiAPIRequest + KanaKanjiResponse) and the KPAPISession will automatically decode the response to that.

👍 Define different types of Error for API Response. Also CustomStringConvertible to ensure every type of error have its own description. App only need to show the description to the User by Business logic.


**Combine:**

👍 Almofire support combine start from 5.2, the mapError operator is convenient and let me group all errors from API to APIError. 

👍 publishDecodable also is very great for automatically decode the api response to the object type I want.

👍 flatMap can handle the Published result to ANOTHER Publisher type I want. In this project sample, I use it to change Almofire respone to Future<T.Model, APIError>.

**SwiftUI**

👍 Status base design, it is convenient the UI will be update when the value of viewModel was changed

**MVVM**

👍 In MVC, the ViewController will mix up UI logic and business logic. It will make the source code longer and longer, maybe unreadable when the project become very large scale. MVVM seperate the UI and business logic to View and ViewModel. The code is more clean and easy to read.

👍 In MVC, when doing Testing, it need to mock a ViewController for testing and cannot seperate the UI and business logic. But in MVVM, only need to test the viewModel class without any UI logic.

## Bad points👎👎
**SwiftUI**

👎 SwiftUI is Status base. If the App Flow design is not clear, the code will mess up. And also if there was a BIG update on App Flow, it maybe hard to modify the UI if it is made by SwiftUI.

👎 It is still new (actually not very new, but still not many companies using this as I know) so need to take more time and cost to learn.

👎 In my opinion, it is still not very good timing to developer some business app because it still not stable enough and Apple is still optimizing it.

👎 But it is nice if doing some project that small and prefer not to do many maintance in future

**Combine**

👎 Same as SwiftUI, it is new framework (actually not very new, but still not many companies using this as I know) so need to take more time and cost to learn.

👎 I think it is okay to use Combine in business framework if the OS requirment of the project is over iOS13, but if it is not a new app, it will be quite hard to modify all the old code to combine. Maybe better do it when refractoring or new project.

## Things can be improved

1. The APISession just have one function because of this project is just a practice. It can be extent more in future. (e.g. download, upload...etc).
2. Combine have a lot of operator, if understand more about them, it should be more powerful and make the code more convenient.
3. More function in SwiftUI can be learnt and use to create more beautiful UI
4. Hope can have more time to try on business project. Many times you cannot see the real problems of some new technology if you never using it on a businese project.
