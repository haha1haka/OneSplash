<img width="955" alt="스크린샷 2022-12-12 18 05 57" src="https://user-images.githubusercontent.com/106936018/207005184-20f3764b-6540-4803-a935-569a2b8a358a.png">

<br/><br/><br/>

# OneSplash
> *개발기간: 2022.10.20 ~ 2022.10.27*

* Unsplash API 를 이용해, 기획 디자인 개발을 진행한 앱 입니다.
* 원하는 photo Topic 을 불러 올 수 있고 사진을 앱 Document directory folder에 저장하고 불러올 수 있습니다.
* 원하는 사진을 검색하고 저장 할 수 있습니다.

<br/><br/>

# Table Of Contents
* #### [Tech Stack](https://github.com/haha1haka/OneSplash#tech-stack-1)
* [Tech Posting](https://github.com/haha1haka/OneSplash#used-tech-posting)
* [Application architecture](https://github.com/haha1haka/OneSplash#application-architecture)
* [Simulation](https://github.com/haha1haka/OneSplash#simulation)
* [회고](https://github.com/haha1haka/OneSplash#%ED%9A%8C%EA%B3%A0)

    

<br/><br/>

## Tech Stack 
* #### MVVM, MVC
* Swift5.7
* UIKit
* RxSwift
* RxCocoa
* URLSession
* Snapkit
* RealmDatabase
  

<br/><br/>

## Used Tech Posting

* [MVC 와 MVVM](https://github.com/haha1haka/iOS-Topics/issues/29)
* [UICollectionViewCompositiaonlLayout](https://github.com/haha1haka/iOS-Topics/issues/1)
* [UICollectionViewDiffableDatasSource](https://github.com/haha1haka/iOS-Topics/issues/3)
* [UISearchViewController](https://github.com/haha1haka/iOS-Topics/issues/18)
* [SingletonPattern](https://github.com/haha1haka/iOS-Topics/issues/30)
* [RepositoryPattern](https://github.com/haha1haka/iOS-Topics/issues/20)
* RxSwift, RxCocoa(updating...)
* Network Router Pattern(updating...)







<br/><br/>



## Application architecture

<br/>

<img width="1215" alt="스크린샷 2022-12-13 15 50 32" src="https://user-images.githubusercontent.com/106936018/207246485-1fdb6fa4-525a-417e-a895-20e8daab3528.png">

MVVM 아키텍쳐를 이용하여, viewController 에 있던 model 과 model 관련 business logic 을 viewModel로 분리 하였습니다.

Rx를 이용하여, emit 한 data 를 controller 에서 bind 처리(UI update) 하였습니다.

<br/><br/>



## Simulation



### 1. Request Topic and Topic'sPhoto API



![1](https://user-images.githubusercontent.com/106936018/207250648-8c2c3cf8-5217-4b1e-b6be-a771a7ee7680.gif)

앱 시작과 동시에  topic api 호출 합니다

원하는 topic 을 클릭시 해당 topic의 photo 들을 요청하고 받아 옵니다.



<br/>

### 2. Detail photos 확인 및 저장하기



![2](https://user-images.githubusercontent.com/106936018/207250891-86edf2aa-7ca9-499d-98f3-22a3a74ecc13.gif)



api 에서 넘어오는 Photo **height** 와 **width** 를 **preferredLayoutAttributesFitting** 매서드를 통해 높이를 재조정후 return 합니다.

```swift
override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    let attributes = super.preferredLayoutAttributesFitting(layoutAttributes)
    guard let photoItem = photoItem else { return attributes }
    let ratio = CGFloat(photoItem.height) / CGFloat(photoItem.width)
    let newHeight = attributes.bounds.width * ratio
    attributes.bounds.size.height = newHeight
    return attributes
}
```

<br/>



### 3. Search Photos and 최근 검색어 기능 추가 및 삭제



![3](https://user-images.githubusercontent.com/106936018/207252614-cc1bdfd9-d67c-4306-9d1e-933ece5557d3.gif)

search 했을시 text 를 DB 에 저장 하고 collectionView 에 데이터를 구성합니다.

clear 버튼 클릭시 DB 상에 데이터도 지워주고 collectionView snapshot 도 다시 그려줍니다.



<br/>



### 4. AlbumPhotos

![4](https://user-images.githubusercontent.com/106936018/207251980-2afeb540-4f10-4fce-82c3-5ca9b28c062b.gif)



저장 버튼 클릭시, FileManger 를 통해 내앱의 Document 폴더에 저장합니다.

collectionView cell image 구성시, document에 있는 image 를 load 해 옵니다 

<img width="954" alt="스크린샷 2022-12-13 17 27 27" src="https://user-images.githubusercontent.com/106936018/207264498-0dd4e255-c6fa-464b-b98b-80ed98a04504.png">

> ✅DB(realm) 를 이용해서도 실습 완료



<br/><br/>



## 회고

<br/>





