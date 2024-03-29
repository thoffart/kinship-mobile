import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:kinship_mobile/app-state.dart';
import 'package:kinship_mobile/keys.dart';
import 'package:kinship_mobile/models/post-arguments.dart';
import 'package:kinship_mobile/pages/home-page/posts-list-page/+model/posts-list-page-model.dart';
import 'package:kinship_mobile/pages/home-page/posts-list-page/+state/posts-list-page-actions.dart';
import 'package:kinship_mobile/utils/loadmore-custom-widget/loadmore-custom-widget.dart';
import 'package:kinship_mobile/utils/post-card-widget/post-card-widget.dart';

class PostsListPage extends StatelessWidget {

  Future<bool> _loadMore(Function getMorePosts) async {
    getMorePosts();
    await Future.delayed(Duration(seconds: 2));
    return true;
  }

  Future<void> _refresh(Function refreshPosts) async {
    refreshPosts();
    await Future.delayed(Duration(seconds: 2));
  }

  Widget _listPosts(
    List<Map<String, dynamic>> posts,
    int offset,
    Function getMorePosts,
    Function refreshPosts,
  ) => RefreshIndicator(
    child: LoadMoreCustom(
      isFinish: offset > posts.length,
      onLoadMore: () => _loadMore(getMorePosts),
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () => Keys.navKey.currentState.pushNamed(
              'post-detalhe-page',
              arguments: PostArguments(posts[index]),
            ),
            child: Column(
              children: <Widget>[
                PostCardWidget(post: posts[index]),
                SizedBox(height: 4),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(thickness: 2),
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
    onRefresh: () => _refresh(refreshPosts),
  );

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, PostsListPageModel>(
      converter: (store) => PostsListPageModel.fromStore(store),
      onInit: (store) {
        if(store.state.postsListPageState.firstBuild) {
          store.dispatch(new LoadPosts());
        }
      },
      builder: (context, postsListPageModel) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Stack(
                children: <Widget> [
                  !postsListPageModel.firstBuild 
                    ? (postsListPageModel.posts != null)
                        ? _listPosts(
                          postsListPageModel.posts,
                          postsListPageModel.offset,
                          postsListPageModel.getMorePosts,
                          postsListPageModel.refreshPosts,
                        )
                        : Center(child: Text('Não há posts'))
                    : Center(child: CircularProgressIndicator()),
                  Positioned(
                    child: RawMaterialButton(
                      child: Icon(
                        Icons.add,
                        size: 40,
                        color: Colors.white,
                      ),
                      onPressed: () => Keys.navKey.currentState.pushNamed('create-post-page'),
                      shape: new CircleBorder(),
                      elevation: 2.0,
                      fillColor: Colors.pink[900],
                      padding: const EdgeInsets.all(5.0),
                      splashColor: Colors.white,
                    ),
                    bottom: 20,
                    right: 8,
                  ),
                ]
              ),
            )
          ],
        );
      },
    );
  }
}


