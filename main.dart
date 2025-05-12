import 'package:flutter/material.dart';

void main() {
  runApp(SummerClothesApp());
}

class SummerClothesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Summer Wear Shop',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Arial',
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedCategory = 'All';
  final List<String> categories = ['All', 'T-Shirts', 'Shorts', 'Dresses', 'Accessories'];

  final List<Item> allItems = [
    Item('Floral Dress', 39.99, 'assets/images/image1.png', 'Dresses'),
    Item('Beach Hat', 15.99, 'assets/images/beach hat.jpg', 'Accessories'),
    Item('White T-Shirt', 12.99, 'assets/images/white t shirt.jpg', 'T-Shirts'),
    Item('Denim Shorts', 24.99, 'assets/images/shorts.jpg', 'Shorts'),
    Item('Sunglasses', 19.99, 'assets/images/sunglasses.jpg', 'Accessories'),
  ];

  final List<Item> cartItems = [];

  void addToCart(Item item) {
    setState(() {
      cartItems.add(item);
    });
  }

  double get totalPrice => cartItems.fold(0, (sum, item) => sum + item.price);

  @override
  Widget build(BuildContext context) {
    List<Item> displayedItems = selectedCategory == 'All'
        ? allItems
        : allItems.where((item) => item.category == selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Summer Clothes'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Row(
                children: [
                  Icon(Icons.shopping_cart),
                  SizedBox(width: 6),
                  Text('\$${totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (bool selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(10),
              children: displayedItems.map((item) => ItemCard(item: item, onAddToCart: addToCart)).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class Item {
  final String name;
  final double price;
  final String imagePath;
  final String category;

  Item(this.name, this.price, this.imagePath, this.category);
}

class ItemCard extends StatelessWidget {
  final Item item;
  final void Function(Item) onAddToCart;

  const ItemCard({required this.item, required this.onAddToCart});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                item.imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              item.name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text('\$${item.price.toStringAsFixed(2)}'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ElevatedButton(
              onPressed: () => onAddToCart(item),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Add to Cart'),
            ),
          ),
        ],
      ),
    );
  }
}