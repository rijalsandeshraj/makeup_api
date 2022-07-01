import 'package:flutter/material.dart';
import 'package:makeup_api/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);

    Future<void> showAlertDialog() async {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete All Items?'),
              content: const Text(
                  'Are you sure about deleting all the items from cart?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    cartProvider.removeAll();
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        duration: const Duration(seconds: 1),
                        backgroundColor:
                            Theme.of(context).primaryColor.withOpacity(0.8),
                        content:
                            const Text('All items deleted successfully!')));
                    Navigator.pop(context);
                  },
                  child: const Text('YES'),
                ),
              ],
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Items'),
        actions: [
          if (cartProvider.cartItems.isNotEmpty)
            Row(
              children: <Widget>[
                const Text('Delete all'),
                IconButton(
                  onPressed: () {
                    showAlertDialog();
                  },
                  icon: const Icon(Icons.delete_forever_rounded),
                ),
              ],
            )
        ],
      ),
      body: cartProvider.cartItems.isEmpty
          ? Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  clipBehavior: Clip.hardEdge,
                  child: const Image(
                    image: AssetImage('assets/empty_cart.gif'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'No Items Added to Cart!',
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
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(8),
                  height: 100,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.deepOrange,
                  ),
                  child: Text(
                    'Total\n\$ ${cartProvider.totalPrice}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8),
                          leading: Text(
                            '\$ ${cartProvider.cartItems[index].price!}',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          title: Text(
                            cartProvider.cartItems[index].name!,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Container(
                                height: 24,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    iconSize: 27,
                                    icon: const Icon(
                                      Icons.remove,
                                    ),
                                    onPressed: () {
                                      cartProvider.removeOne(
                                          cartProvider.cartItems[index]);
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                height: 24,
                                width: 30,
                                color: Colors.grey.shade200,
                                child: Center(
                                  child: Text(
                                    '${cartProvider.cartItems[index].orderQuantity}',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              Container(
                                height: 24,
                                width: 30,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: FittedBox(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    iconSize: 27,
                                    alignment: Alignment.center,
                                    icon: const Icon(
                                      Icons.add,
                                    ),
                                    onPressed: () {
                                      cartProvider
                                          .add(cartProvider.cartItems[index]);
                                    },
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.blue,
                                  size: 26,
                                ),
                                onPressed: () {
                                  cartProvider
                                      .remove(cartProvider.cartItems[index]);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          duration: const Duration(seconds: 1),
                                          backgroundColor: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(0.8),
                                          content: const Text(
                                              'Item has been deleted!')));
                                },
                              ),
                            ],
                          ),
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
