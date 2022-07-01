import 'package:flutter/material.dart';
import 'package:makeup_api/providers/cart_provider.dart';
import 'package:makeup_api/providers/favorite_provider.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    var favoriteProvider = Provider.of<FavoriteProvider>(context);
    var cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        actions: [
          if (favoriteProvider.favoriteItems.isNotEmpty)
            Row(
              children: <Widget>[
                const Text('Remove all'),
                IconButton(
                  onPressed: () {
                    favoriteProvider.removeAll();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 2),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.8),
                        content:
                            const Text('All items removed from Favorites!')));
                  },
                  icon: const Icon(Icons.delete_forever),
                ),
              ],
            )
        ],
      ),
      body: favoriteProvider.favoriteItems.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: const Image(
                    image: AssetImage('assets/favorite.gif'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'No Items Added to Favorites!',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: favoriteProvider.favoriteItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Row(
                          children: [
                            Container(
                              width: 300,
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 3,
                                ),
                              ),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                    height: 110,
                                    child: Image.network(
                                      favoriteProvider
                                          .favoriteItems[index].imageLink!,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, err, stackTrace) {
                                        return Image.network(
                                            'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?'
                                            'ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8f'
                                            'Hx8&auto=format&fit=crop&w=1035&q=80');
                                      },
                                    ),
                                  ),
                                  // Divider(
                                  //   thickness: 3,
                                  //   color: Colors.blueGrey.shade100,
                                  // ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          favoriteProvider
                                                  .favoriteItems[index].name ??
                                              'N/A',
                                          textAlign: TextAlign.center,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 3,
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Brand: ${favoriteProvider.favoriteItems[index].brand}',
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '\$ ${favoriteProvider.favoriteItems[index].price}',
                                          style: TextStyle(
                                            color:
                                                Theme.of(context).primaryColor,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Add to\nCart',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                  Container(
                                    width: 40,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      color: Colors.amber,
                                      shape: BoxShape.circle,
                                    ),
                                    child: FittedBox(
                                      child: IconButton(
                                        icon: const Icon(Icons.add),
                                        iconSize: 36,
                                        onPressed: () {
                                          cartProvider.add(favoriteProvider
                                              .favoriteItems[index]);
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
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Text(
                                    'Remove from\nFavorites',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.deepPurple),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    width: 40,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueGrey),
                                      color: Colors.amber,
                                      shape: BoxShape.circle,
                                    ),
                                    child: FittedBox(
                                      child: IconButton(
                                        icon: const Icon(Icons.close_rounded),
                                        iconSize: 36,
                                        onPressed: () {
                                          favoriteProvider.removeFavorite(
                                              favoriteProvider
                                                  .favoriteItems[index]);
                                          favoriteProvider.favoriteItems[index]
                                              .isfavorite = false;
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .primaryColor
                                                          .withOpacity(0.8),
                                                  content: const Text(
                                                      'Item removed From Favorites!')));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
