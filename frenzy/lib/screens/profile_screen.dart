import 'package:flutter/material.dart';
import 'package:frenzy/models/user_model.dart';
import 'package:frenzy/widgets/custom_drawer.dart';
import 'package:frenzy/widgets/posts_carousel.dart';
import 'package:frenzy/widgets/profile_clipper.dart';

class ProfileScreen extends StatefulWidget
{
  final User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
{

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  PageController _yourPostPageController;
  PageController _favoritesPageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _yourPostPageController = PageController(initialPage: 0, viewportFraction: 0.8);
    _favoritesPageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: <Widget>[
                ClipPath(
                  clipper: ProfileClipper(),
                  child: Image(
                    height: 240.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    image: AssetImage(widget.user.backgroundImageUrl),
                  ),
                ),
                Positioned(
                  top: 30.0,
                  left: 10.0,
                  child: IconButton(
                    icon: Icon(Icons.menu),
                    iconSize: 30.0,
                    color: Theme.of(context).primaryColor,
                    onPressed: ()=>_scaffoldKey.currentState.openDrawer(),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black45,
                          offset: Offset(0, 2),
                          blurRadius: 6.0,
                        )
                      ]
                    ),
                    child: ClipOval(
                      child: Image(
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                        image: AssetImage(widget.user.profileImageUrl,),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(15.0),
              child: Text(widget.user.name, style: TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5
              ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Text('Following', style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0
                    ),
                    ),
                    SizedBox(height: 2.0),
                    Text(widget.user.following.toString(), style: TextStyle(
                     fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    Text('Followers', style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0
                    ),
                    ),
                    SizedBox(height: 2.0),
                    Text(widget.user.followers.toString(), style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                  ],
                )
              ],
            ),
            PostsCarousel(
              pageController: _yourPostPageController,
              title: 'Your Posts',
              posts: widget.user.posts,
            ),
            PostsCarousel(
              pageController: _favoritesPageController,
              title: 'Favorites',
              posts: widget.user.favorites,
            ),
            SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
