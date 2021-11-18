import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:page_transition/page_transition.dart';
import 'package:tamasha/Model/news.dart';
import 'package:tamasha/Network/api_request.dart';
import 'package:tamasha/screen/news_detail.dart';
import 'package:tamasha/state/state_management.dart';

import 'Model/articles.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News app',

      onGenerateRoute: (settings){
        switch(settings.name){
          case '/detail':
       return PageTransition(child: MyNewsDetails(), type: PageTransitionType.fade,
       settings: settings);
       break;
       default:
       return null;
        }
      },
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
        accentColor: Colors.teal,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin{

  final List<Tab>tabs =<Tab>[
    new Tab(text: 'General',),
    new Tab(text: 'Technology',),
    new Tab(text: 'Sports',),
    new Tab(text: 'Business',),
    new Tab(text: 'Entertainment',),
    new Tab(text: 'Health',),
  ];

   TabController? _tabController;

  @override
  void initState() {
    _tabController=new TabController(length: tabs.length, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Text('Dark News'),
    bottom:
    TabBar(
    isScrollable: true,
    unselectedLabelColor: Colors.grey,
    labelColor: Colors.white,
    indicatorSize:TabBarIndicatorSize.tab ,
    indicator: BubbleTabIndicator(
    indicatorHeight: 25.0,
    indicatorColor: Colors.orange,
    tabBarIndicatorSize: TabBarIndicatorSize.tab,),
      tabs:tabs,
      controller: _tabController,
    ),
    ),

    body: TabBarView(controller:_tabController,children: tabs.map((tab){

      return FutureBuilder(future: fetchNewsByCategory(tab.text!),
          builder: (context,snapshot){
        if(snapshot.hasError)return Center(child: Text('${snapshot.error}'),);
        else if(snapshot.hasData){
          var newList=snapshot.data as News;
          var sliderList=newList.articles!=null?newList.articles!.length>10?
              newList.articles!.getRange(0, 10).toList():newList.articles!.take(newList.articles!.length).toList():[];
         var contentList=newList.articles!=null?newList.articles!.length>10?newList.articles!.getRange(11, newList.articles!.length-1).toList():[]:[];
          return SafeArea(child: Column(
            children: [
              CarouselSlider(options:
              CarouselOptions(
                aspectRatio: 16/9,enlargeCenterPage: true,viewportFraction:0.8
              ),
                  items: sliderList.map(( item) {
                    return Builder
                      (builder: (context) {
                      return
                        GestureDetector(
                          onTap: (){
                            context.read(urlState).state=item.url;
                            Navigator.pushNamed(context, '/detail');
                          }, child: Stack(children: [
                          ClipRRect(borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${item.urlToImage}', fit: BoxFit.cover,),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Color(0xAA333639),
                                child: Padding(
                                  padding: const EdgeInsets.all(8), child:
                                Text('${item.title}',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),),),
                              )
                            ],
                          )
                        ],),);
                    },
                    );
                  }).toList(),
              ),
              Divider(thickness: 3,),
              Padding(padding: const EdgeInsets.only(left: 8),
                child: Text('Trending*',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),),
              Divider(thickness: 3,),
              Expanded(child: ListView.builder(
                  itemCount: contentList.length,
                  itemBuilder: (context,index){
                    return GestureDetector(onTap: (){
                      context.read(urlState).state=contentList[index].url;
                      Navigator.pushNamed(context, '/detail');
                    },child:
                      ListTile(leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network('${contentList[index].urlToImage}',
                        fit: BoxFit.cover,
                        height: 80,
                        width: 80,),
                      ),
                        title: Text('${contentList[index].title}',
                        style: TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Text('${contentList[index].publishedAt}',
                        style: TextStyle(fontStyle: FontStyle.italic),),
                        ),);

                  })),
            ],
          ));
        }
        else return Center(child: CircularProgressIndicator(),);
          });
    }).toList(),
    ),
    );
  }
}



