# GoodsmartNews
An app that shows latest news.

## Technologies and Libraries

#### - Alamofire
I used AF to make request calls to the endpoints

#### - RxSwift
It is used to handle the asynchronous operations in the app

#### - CompositionalViewLayout
The home page is consisted of mmultiple sections that are different from each other, CompositionalViewLayout helps to make these sections easily with less code.

#### - MVVM
I used MVVM with a state that the View reacts to it, when the state changes something changes in the View, also I used an effect, to represent actions that the view should take, the effect is different from state, the state is persistent and the effect is one shot.

#### - Clean Architecture
I separated the logic in the app into different layers, Application Layer, Domain Layer and Data Layer.
Also I separated the logic of providing the data and fetching it into data sources, and made the repo only responsible for mapping the objects.
I followed the single source of truth concept in making the StockDataSource, where I am making request to get the stock tickers and I save them to database and then call the database to return the data, when I call it again the source returns the data saved in the database, the Database is my single source of truth.
However, in NewsDatasource, I only saved maximum of 10 articles, so I used a merge technique to merge the result from the database with API.

#### - PinRemoteImg
I used it to load images into UIIMageView

#### - SVProgressHUD
I used to indicate long-running operations
