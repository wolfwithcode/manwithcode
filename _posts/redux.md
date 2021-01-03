---
title: 'Học React/Redux qua ví dụ thực tế: Redux'
excerpt: 'Học React/Redux qua ví dụ thực tế: Redux'
coverImage: '/assets/blog/preview/cover.jpg'
date: '2020-12-12T05:35:07.322Z'
author:
  name: Code A holic guy
  picture: '/assets/blog/authors/joe.jpeg'
ogImage:
  url: '/assets/blog/preview/cover.jpg'
---

# Học React/Redux qua ví dụ thực tế: Redux

[codeaholicguy](https://codeaholicguy.com/author/hoangnn93/ "Đăng bởi codeaholicguy")  [Chuyện coding](https://codeaholicguy.com/category/chuyen-coding/),  [Học React/Redux qua ví dụ thực tế](https://codeaholicguy.com/category/chuyen-coding/hoc-reactredux-qua-vi-du-thuc-te/),  [Javascript](https://codeaholicguy.com/category/chuyen-coding/javascript/),  [ReactJS](https://codeaholicguy.com/category/chuyen-coding/javascript/reactjs/),  [Redux](https://codeaholicguy.com/category/chuyen-coding/javascript/redux/)  08/16/2016  9 Minutes

Thời gian vừa rồi, nào là tham gia Facebook Hackathon VietNam, cũng may mắn là có giải, chắc chắn tôi sẽ kể cho các bạn nghe vào một ngày gần nhất.

![facebookhackathonbest-marketing-1470035310.jpg](https://codeaholicguy.files.wordpress.com/2016/08/facebookhackathonbest-marketing-1470035310.jpg?w=1100)

Tôi là thanh niên mặc áo khoác đừng giữa đấy!

Rồi sau đó lại rong ruổi đạp xe năm bảy chục cây số để bắt Pokemon làm tôi không thể đăng bài mới được, nhưng không sao, tôi đã trở lại để tiếp tục giúp các bạn tìm hiểu React/Redux đây. Hôm nay chúng ta sẽ tiếp tục tìm hiểu về Redux và vai trò của nó trong application.

Redux được mô tả như là một predictable state container cho application. Phần lớn các bạn thường thấy Redux được đi một cặp với ReactJS ở client side application. Thực tế, Redux còn hơn thế, giống như Javascript đã lấn sân sang server side với NodeJS hay dùng trong việc phát triển IoT application, Redux có thể được sử dụng ở bất cứ nơi đâu cần một predictable state container. Bạn phải hiểu và nắm bắt được vấn đề mà nó giải quyết, thì mới nên sử dụng nó.

Nào cùng bắt đầu tìm hiểu Redux thôi.

## Cách mà Redux làm việc

Nói một cách đơn giản, bạn sẽ trigger một action trong component, nó có thể là một button, một text field, hay blabla… sẽ có một thành phần khác listen đến cái action mà bạn vừa trigger, sử dụng payload mà action đó trả về, sinh ra một global state mới từ payload đó sau đó trả ngược lại cho component để nó thực hiện nhiệm vụ render lại nếu cái global state đó có thay đổi so với global state trước đó. Khi component được render xong thì lúc đó chu trình coi như hoàn tất.

Lý thuyết thế đủ rồi, còn chờ gì nữa mà không bắt tay vào implement nhỉ!

Từ folder của project các bạn cài đặt như sau.

npm install --save redux redux-logger

## Dispatch action

Bây giời chúng ta sẽ tạo  `action`  đầu tiên. Mở file  `src/index.js` lên.

    import React from 'react';
    
    import ReactDOM from 'react-dom';
    
    import TrackList from './components/TrackList';
    
    import {configureStore} from './store';
    
    import * as actions from './actions';
    
    const tracks = [
    
    {
    
    id: 1,
    
    title: 'Em của ngày hôm qua'
    
    },
    
    {
    
    id: 2,
    
    title: 'Cơn mưa ngang qua'
    
    }
    
    ];
    
    const store = configureStore();
    
    store.dispatch(actions.setTracks(tracks));
    
    ReactDOM.render(
    
    <TrackList />,
    
    document.getElementById('app')
    
    );

Như các bạn có thể thấy, chúng ta cài đặt một store object bằng function  `configureStore`, chúng ta chưa vội implement nó lúc này. Hãy tìm hiểu store là gì trước đã. Store là một singleton object trong Redux, và giữ vai trò như là global state object. Hơn thế nữa, nó có khả năng sử dụng một số API để dispatch một action, lấy được trạng thái của store hay notify nếu store có sử thay đổi.

Trong trường hợp này, chúng ta đang dispatch action với payload là list track đã được hard code. Và vì thế chúng ta sẽ không cần phải pass tracks vào trong component như trước nữa, chúng đã không còn thuộc về nhau anymore. Haha.

Tiếp theo sẽ làm gì đây nhỉ? Suy nghĩ nào, chúng ta sẽ implement function  `configureStore` để sinh ra store object hay chúng ta sẽ bắt đầu xem phần dispatch action. Tôi nghĩ là chúng ta sẽ tiếp tục với việc giải thích về action và action creator, tìm hiểu về reducer, cái mà sẽ giải quyết global state khi nhận được payload từ action, rồi cuối cùng mới quay lại việc setup store. Các bạn thấy thế nào? Nói vậy thôi chứ khi các bạn đọc đường những dòng này thì gạo đã được nấu thành cơm rồi, nên khỏi ý kiến nhé!

## Action Types

Chúng ta cần một file để chứa constant, những constant đầu tiên sẽ là những constant để giải quyết việc xác định action nào. Những constant này sẽ được sử dụng bởi cả reducer và action.

Tạo file  `src/core/constants.js`.

    export const ActionTypes = {
    
    TRACKS_SET: 'TRACKS_SET'
    
    }

## Action Creators

Bây giờ chúng ta sẽ tìm hiểu về action creator. Action creator sẽ trả về một object với type và payload. Type là một trong số những constant  `ActionTypes` mà chúng ta đã tạo ở trên. Payload có thể là bất cứ thứ gì, nó sẽ được sử dụng để thay đổi global state của application.

Có nhiều cách để structure một React/Redux application, trong bài này tôi sẽ dùng cách đơn giản nhất, chắc chắn sau series này, chúng ta sẽ có thêm một vài bài để refactor cũng như structure lại cho code base đẹp hơn.

Tạo  `src/actions/tracks.js`.

    import {ActionTypes} from '../core/constants';
    
    export function setTracks(tracks) {
    
    return {
    
    type: ActionTypes.TRACKS_SET,
    
    tracks
    
    };
    
    };


Action creator đầu tiên của chúng ta sẽ nhận vào input là list tracks, cái mà chúng ta sẽ set vào global state. Action creator này sẽ trả về một object chứa action type và payload là list mà chúng ta đã truyền vào.

Để giữ cho folder structure gọn gàng, mặc dù là cách cơ bản nhưng chúng ta cũng nên tạo một file  `index.js` trong folder  `actions` để chứa tất cả các action creator như sau.

    import {setTracks} from './track';
    
    export {
    
    setTracks
    
    };



Trong file này chúng ta sẽ bundle tất cả các action creator mà chúng ta có và export chúng ra như là một public interface cho các phần còn lại sử dụng.

## Reducer

Sau khi dispatch action và implement action creator, chúng ta phải implement thứ mà ai cũng biết là thứ gì, nó làm nhiệm vụ canh chừng nếu có bất cứ action nào được gọi và update global state. Nó được gọi là reducer, bởi vì sao nó lại được gọi như vậy? Nói một cách đơn giản nó nhận vào type và payload action trả về, và từ đó biến state cũ thành state mới. Lưu ý rằng thay vì thay đổi state trước đó thì chúng ta sẽ trả về một object state mới, state là immutable.

State trong redux phải là immutable. Bạn sẽ không thể thay đổi state mà phải trả về một object state mới, việc này nhằm mục đích tránh những side effect trong application, chúng ta sẽ nói sâu hơn về vấn đề tại sao state lại phải là immutable trong một bài khác, vì nó vượt qua khuôn khổ mà chúng ta muốn biết trong bài này.

Nào cùng tạo reducer. Tạo file  `src/reducers/track.js`.

    import {ActionTypes} from '../core/constants';
    
    const initialState = [];
    
    export default function(state = initialState, action) {
    
    switch (action.type) {
    
    case ActionTypes.TRACKS_SET:
    
    return setTracks(state, action);
    
    }
    
    return state;
    
    }
    
    function setTracks(state, action) {
    
    const {tracks} = action;
    
    return [...state, ...tracks];
    
    }

Như các bạn có thể thấy, chúng ta sẽ export một anonymous function. Reducer sẽ nhận vào một state và action như tôi đã nói từ trước. Bản thân reducer sẽ phải handle nhiều action type khác nhau, bây giờ thì các bạn nhìn thấy có một, nhưng trong tương lai khi application phình to ra thì cũng nhiều đáng kể đấy. Cũng giống như cách chúng ta làm với action creator, chúng ta sẽ tạo một file  `index.js` trong folder  `reducers` để chứa hết tất cả reducer, và cung cấp ra cho các thành phần khác của application sử dụng.

    import {combineReducers} from 'redux';
    
    import track from './track';
    
    export default combineReducers({
    
    track
    
    });



Để tiết kiệm thời gian, chúng ta sẽ sử dụng helper function của Redux, đó là  `combineReducers`. Thông thường bạn sẽ phải export từng reducer, reducer đó sẽ phải trả về toàn bộ state của application. Khi sử dụng  `combineReducers`, bạn có thể sử dụng multiple reducer mỗi reducer sẽ trả về một substate. Nếu không sử dụng nó bạn sẽ phải access list tracks trong global state như thế này.

state.tracks

Nhưng với  `combineReducers`, bạn sẽ get thẳng từ subset của state như sau.

state.track.tracks

## Setting Store

Rồi, chúng ta đã có action, đã có action type và action creator, rồi chúng ta cũng đã có reducer để xử lý new state. Giờ chúng ta chỉ còn thiếu mỗi store, cái mà chúng ta đã làm từ lúc đầu nhưng vẫn bỏ ngõ trong file  `src/index.js`.

Hãy nhớ rằng, chúng ta đã dispatch action thông qua store api dispatch.

store.dispatch(actionCreator(payload))

Nào cũng tạo store. Tạo file  `src/store.js`.

    import {createStore, applyMiddleware} from 'redux';
    
    import createLogger from 'redux-logger';
    
    import rootReducer from '../reducers/index';
    
    const logger = createLogger();
    
    const createStoreWithMiddleware = applyMiddleware(logger)(createStore);
    
    export function configureStore(initialState) {
    
    return createStoreWithMiddleware(rootReducer, initialState);
    
    }



Redux cung cấp cho chúng ta function  `createStore`. Chúng ta chỉ cần function này với những combined reducer chúng ta đã tạo trước đó để tạo store.

Redux store được khai báo với một middleware, thành phần này sẽ có nhiệm vụ để làm một số nhiệm vụ gì đó giữa khoảnh khắc dispatch action và khoảnh khác payload đến được với reducer. Có hàng tá middleware cho Redux ở ngoài kia, trong bài này, tôi chỉ sử dụng logger middleware để bắt đầu, cũng như để cho các bạn biết tới middleware là gì. Logger middleware sẽ console log previousState và nextState mỗi khi có action. Giúp chúng ta có thể keep track application một cách dễ dàng hơn.

Cuối cùng chúng ta sử dụng helper function  `applyMiddleware` để wire store và middleware chúng ta vừa khai báo.

Việc gì cần làm cũng đã làm xong rồi, thử  `npm start` để xem thành quả nào!

Lúc này bạn sẽ thấy browser có một màu trắng tinh khôi, nhưng đừng vội buồn vì có lỗi, hãy mở console lên nào, chúng ta sẽ thấy action đã được dispatch.

![Screen Shot 2016-08-16 at 12.52.13 AM.png](https://codeaholicguy.files.wordpress.com/2016/08/screen-shot-2016-08-16-at-12-52-13-am.png?w=1100)

action đã được dispatch rồi nè!

Tuy nhiên thì vì chúng ta chưa connect component  `TrackList` với store nên trang trắng là điều đương nhiên.

Cùng chờ đợi bài viết tiếp theo để kết nối giữa React và Redux nhé!

Source code trong bài các bạn có thể tìm thấy ở [https://github.com/codeaholicguy/react-redux-tutorial/tree/master/redux](https://github.com/codeaholicguy/react-redux-tutorial/tree/master/redux)

Vẫn câu nói cũ đừng quên để lại cho tôi mọi ý kiến đóng góp của các bạn phía bên dưới bài viết nhé, tạm biệt!

Series được tham khảo từ:  [https://www.robinwieruch.de/the-soundcloud-client-in-react-redux/](https://www.robinwieruch.de/the-soundcloud-client-in-react-redux/)