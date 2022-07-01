import 'package:flutter/material.dart';
import 'package:makeup_api/models/product.dart';
import 'package:makeup_api/providers/cart_provider.dart';
import 'package:makeup_api/providers/favorite_provider.dart';
import 'package:makeup_api/screens/cart_screen.dart';
import 'package:makeup_api/screens/favorite_screen.dart';
import 'package:makeup_api/services/http_helper.dart';
import 'package:provider/provider.dart';

class ProductsOverviewScreen extends StatefulWidget {
  const ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

enum ScrollOptions {
  scrollToTop,
  animateTo,
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool isfavorite = false;
  bool _isLoading = true;
  List<Product> productsList = [];
  int startIndex = 0;
  int endIndex = 50;
  int totalPages = 0;
  int pageCounter = 1;
  final ScrollController _scrollController = ScrollController();

  void callProducts() async {
    HttpHelper helper = HttpHelper();
    List<Product>? products = await helper.getProductList();
    setState(() {
      productsList = products ?? [];
      totalPages = (productsList.length / 50).ceil();
      _isLoading = false;
    });
  }

  void scrollBehavior(ScrollOptions scrollOptions) {
    var sOptions = scrollOptions;

    switch (sOptions) {
      case ScrollOptions.scrollToTop:
        return _scrollController.jumpTo(0);

      case ScrollOptions.animateTo:
        _scrollController.animateTo(0,
            duration: const Duration(seconds: 1), curve: Curves.linear);
    }
  }

  @override
  void initState() {
    callProducts();

    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    List<Product> subList = productsList.isNotEmpty
        ? productsList.sublist(startIndex, endIndex)
        : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Up Pro'),
        actions: [
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(horizontal: 12),
            child: Stack(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const CartScreen()));
                  },
                  icon: Icon(
                    Icons.shopping_cart,
                    size: 25,
                    color:
                        cartProvider.count == 0 ? Colors.white : Colors.amber,
                  ),
                ),
                Positioned(
                  top: 1,
                  right: -2,
                  child: CircleAvatar(
                    radius: 11,
                    child: Text(
                      cartProvider.count.toString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    backgroundColor: cartProvider.count == 0
                        ? Colors.transparent
                        : Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _drawer(context, favoriteProvider),
      bottomNavigationBar: _bottomAppBar(context),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : subList.isEmpty
              ? const Center(child: Text('Could not fetch data!'))
              : GridView.builder(
                  controller: _scrollController,
                  addAutomaticKeepAlives: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 1,
                    mainAxisSpacing: 1,
                    childAspectRatio: 2 / 2.86,
                  ),
                  itemCount: subList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      // height: 440,
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.blueGrey,
                          width: 3,
                        ),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            height: 110,
                            child: Image.network(
                              subList[index].imageLink!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, err, stackTrace) {
                                return Image.network(
                                    'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?'
                                    'ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8f'
                                    'Hx8&auto=format&fit=crop&w=1035&q=80');
                              },
                            ),
                          ),
                          Divider(
                            thickness: 3,
                            color: Colors.blueGrey.shade100,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  productsList
                                          .sublist(startIndex, endIndex)[index]
                                          .name ??
                                      'N/A',
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Brand: ${subList[index].brand}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '\$ ${subList[index].price}',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          cartProvider.add(productsList.sublist(
                                              startIndex, endIndex)[index]);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                  content: const Text(
                                                      'Item added to cart!')));
                                        },
                                        child: const Text(
                                          'Add to Cart',
                                          style: TextStyle(
                                              color: Colors.deepPurple),
                                        ),
                                      ),
                                      const Spacer(),
                                      subList[index].isfavorite &&
                                              favoriteProvider.removeAllClicked
                                          ? IconButton(
                                              icon: const Icon(
                                                Icons.favorite_rounded,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                favoriteProvider.removeFavorite(
                                                    subList[index]);
                                                subList[index].isfavorite =
                                                    false;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.8),
                                                        content: const Text(
                                                            'Item removed From Favorites!')));
                                              },
                                            )
                                          : IconButton(
                                              icon: const Icon(
                                                Icons.favorite_border_rounded,
                                                size: 30,
                                                color: Colors.blue,
                                              ),
                                              onPressed: () {
                                                favoriteProvider.addFavorite(
                                                    subList[index]);
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        duration:
                                                            const Duration(
                                                                seconds: 1),
                                                        backgroundColor:
                                                            Theme.of(context)
                                                                .primaryColor
                                                                .withOpacity(
                                                                    0.8),
                                                        content: const Text(
                                                            'Item added to Favorites!')));
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  Drawer _drawer(BuildContext context, FavoriteProvider favoriteProvider) {
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding: EdgeInsets.zero,
            child: Image.asset(
              'assets/makeup.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.favorite_rounded,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Favorites'),
              trailing: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade400,
                ),
                child: Text(
                  '${favoriteProvider.favoriteItems.length}',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const FavoriteScreen(),
                  ),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.settings,
                color: Theme.of(context).primaryColor,
              ),
              title: const Text('Settings'),
            ),
          ),
        ],
      ),
    );
  }

  BottomAppBar _bottomAppBar(BuildContext context) {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          if (startIndex != 0)
            GestureDetector(
              onTap: () {
                setState(() {
                  startIndex <= 0 ? startIndex = 0 : startIndex -= 50;
                  endIndex <= 50 ? endIndex = 50 : endIndex -= 50;
                  if (endIndex > 850 && endIndex < 900) endIndex = 900;
                  pageCounter = pageCounter - 1;
                });
                scrollBehavior(ScrollOptions.animateTo);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.arrow_back_ios_new,
                      color: Theme.of(context).primaryColor,
                    ),
                    Text(
                      'Previous',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          // const Spacer(),
          if (!_isLoading)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8.0,
              ),
              child: Text(
                'Page $pageCounter / $totalPages',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          if (endIndex != 931 && !_isLoading)
            GestureDetector(
              onTap: () {
                setState(() {
                  startIndex >= 900 ? startIndex = 900 : startIndex += 50;
                  startIndex >= 900 ? endIndex = 931 : endIndex += 50;
                  pageCounter = pageCounter + 1;
                });
                scrollBehavior(ScrollOptions.scrollToTop);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Next',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColor,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
